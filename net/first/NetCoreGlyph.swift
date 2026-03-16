//
//  Nust5.swift
//  SwiftNetVPN
//
//  Created by zying on 2026/3/12.
//

import Foundation
import NetworkExtension
import os
import CommonCrypto
import Network

/// 最底层通道单元：高度抽象命名，逻辑保持与原始实现一致
class NetCoreGlyph {
    var transportChannel: NWConnection?
    var workQueue: DispatchQueue?

    let profile: CoreNodeProfile
    var controlBuffer = Data()
    var tunnelBuffer = Data()

    var loadNetworkSettings: ((NEPacketTunnelNetworkSettings, @escaping (Error?) -> Void) -> Void)?
    var packetFlow: NEPacketTunnelFlow
    
    init(packetFlow: NEPacketTunnelFlow, profile: CoreNodeProfile = .default) {
        self.packetFlow = packetFlow
        self.profile = profile
    }

    func startChannel() {
        #if DEBUG
        os_log("sn.kernel bootstrap", log: OSLog.default, type: .info)
        #endif
        guard let port = NWEndpoint.Port(profile.nodeSlot) else { return }

        let host = NWEndpoint.Host(profile.nodeAlias)
        transportChannel = NWConnection(host: host, port: port, using: .tcp)
        workQueue = .global()
        transportChannel?.stateUpdateHandler = self.handleChannelState(to:)
        if let q = workQueue {
            transportChannel?.start(queue: q)
        }
    }

    func handleChannelState(to state: NWConnection.State) {
        switch state {
        case .ready:
            routeReadyState()
        case .failed(_), .cancelled:
            #if DEBUG
            os_log("sn.kernel stage_error", log: OSLog.default, type: .error)
            #endif
        default: break
        }
    }

    private func routeReadyState() {
        performHandshake()
    }
    
    func performHandshake() {
        #if DEBUG
        os_log("sn.kernel phase_handshake", log: OSLog.default, type: .info)
        #endif
        guard let data = buildHandshakePayload() else { return }
        emitHandshakePayload(data)
    }
    
    private func emitHandshakePayload(_ payload: Data) {
        let encryptedData = obfuscateFrame(data: payload, key: profile.kBeta.data(using: .utf8)!)
        transportChannel?.send(content: encryptedData, completion: .contentProcessed({ [weak self] error in
            guard let self = self, error == nil else { return }
            self.readHeaderFrame()
        }))
    }

    private func readHeaderFrame() {
        transportChannel?.receive(minimumIncompleteLength: 2, maximumLength: 2) { [weak self] data, _, _, error in
            guard let self = self, let data = data, error == nil else { return }
            self.controlBuffer.append(data)
            if self.controlBuffer.count >= 2 {
                let length = self.controlBuffer.prefix(2).withUnsafeBytes { $0.load(as: UInt16.self).bigEndian }
                self.controlBuffer.removeFirst(2)
                self.readBodyFrame(ofLength: Int(length))
            } else {
                self.readHeaderFrame()
            }
        }
    }

    private func readBodyFrame(ofLength length: Int) {
        transportChannel?.receive(minimumIncompleteLength: 1, maximumLength: 1024) { [weak self] data, _, _, error in
            guard let self = self, let data = data, error == nil else { return }
            self.controlBuffer.append(data)
            if self.controlBuffer.count >= length {
                let encryptedResponse = self.controlBuffer.prefix(length)
                self.controlBuffer.removeFirst(length)
                let decryptedResponse = revealFrameData(data: encryptedResponse, key: self.profile.kBeta.data(using: .utf8)!)
                let responseIPs = String(data: decryptedResponse, encoding: .utf8)
                let internalIP = self.extractPrimaryAddress(responseIPs: responseIPs!)
                #if DEBUG
                os_log("sn.kernel internal_addr", log: OSLog.default, type: .debug)
                #endif
                self.applyNetworkSettings(intranetIP: internalIP)
            } else {
                self.readBodyFrame(ofLength: length)
            }
        }
    }

    func applyNetworkSettings(intranetIP: String) {
        let settings = NEPacketTunnelNetworkSettings(tunnelRemoteAddress: CoreNetDefaults.tunnelRemote)
        settings.mtu = CoreNetDefaults.mtu
        settings.dnsSettings = NEDNSSettings(servers: CoreNetDefaults.dnsEndpoints)
        settings.ipv4Settings = {
            let ipv4Settings = NEIPv4Settings(addresses: [intranetIP], subnetMasks: [CoreNetDefaults.ipv4Mask])
            ipv4Settings.includedRoutes = [NEIPv4Route.default()]
            return ipv4Settings
        }()
        loadNetworkSettings?(settings) { [weak self] error in
            guard let self = self, error == nil else { return }
            self.pumpTunToChannel()
            self.pumpChannelToTun()
        }
    }

    func pumpTunToChannel() {
        let secretKey = profile.kBeta.data(using: .utf8)!
        drainIngressPackets(secretKey: secretKey)
    }
    
    private func drainIngressPackets(secretKey: Data) {
        packetFlow.readPackets { [weak self] packets, _ in
            guard let self = self else { return }
            for packet in packets {
                let encryptedData = self.obfuscateFrame(data: packet, key: secretKey)
                self.transportChannel?.send(content: encryptedData, completion: .contentProcessed({ error in
                    if error != nil { return }
                }))
            }
            self.drainIngressPackets(secretKey: secretKey)
        }
    }

    func pumpChannelToTun() {
        drainEgressFrames()
    }
    
    private func drainEgressFrames() {
        transportChannel?.receive(minimumIncompleteLength: 1024, maximumLength: 65535) { [weak self] data, _, _, error in
            guard let self = self, let data = data, !data.isEmpty else { return }
            self.tunnelBuffer.append(data)
            self.consumePayloadBuffer()
            self.drainEgressFrames()
        }
    }

    private func consumePayloadBuffer() {
        let secretKey = profile.kBeta.data(using: .utf8)!
        while tunnelBuffer.count >= 2 {
            let length = tunnelBuffer.prefix(2).withUnsafeBytes { $0.load(as: UInt16.self).bigEndian }
            tunnelBuffer.removeSubrange(0..<2)
            if tunnelBuffer.count >= length {
                let encryptedResponse = tunnelBuffer.prefix(Int(length))
                tunnelBuffer.removeSubrange(0..<Int(length))
                let decryptedResponse = revealFrameData(data: encryptedResponse, key: secretKey)
                let protocolNumber = AF_INET as NSNumber
                packetFlow.writePackets([decryptedResponse], withProtocols: [protocolNumber])
            } else {
                tunnelBuffer.insert(contentsOf: withUnsafeBytes(of: length.bigEndian, Array.init), at: 0)
                break
            }
        }
    }

    func obfuscateFrame(data: Data, key: Data) -> Data {
        CoreFrameCodec.obfuscate(data, key: key, jitterScope: profile.jitterScope)
    }
    
    func extractPrimaryAddress(responseIPs: String) -> String {
        let ips = responseIPs.split(separator: ",").map { String($0) }
        return ips.first ?? ""
    }

    func stopPacketTunnel() {
        transportChannel?.cancel()
    }

    func buildHandshakePayload() -> Data? {
        let dataDict: [String: Any] = [
            CoreFieldKey.pkg: profile.bundleIdTag,
            CoreFieldKey.ver: profile.configRev,
            CoreFieldKey.sdk: "7.0",
            CoreFieldKey.country: profile.zoneId,
            CoreFieldKey.lang: profile.langId,
            CoreFieldKey.action: "new_connect"
        ]
        guard let jsonData = try? JSONSerialization.data(withJSONObject: dataDict, options: []),
              let keyData = profile.kAlpha.data(using: .utf8) else {
            return nil
        }
        let dataToEncrypt = [UInt8](jsonData)
        let keyBytes = [UInt8](keyData)

        var encryptedBytes = [UInt8](repeating: 0, count: dataToEncrypt.count + kCCBlockSizeAES128)
        var numBytesEncrypted = 0
        let status = CCCrypt(
            CCOperation(kCCEncrypt),
            CCAlgorithm(kCCAlgorithmAES),
            CCOptions(kCCOptionPKCS7Padding | kCCOptionECBMode),
            keyBytes,
            keyData.count,
            nil,
            dataToEncrypt,
            dataToEncrypt.count,
            &encryptedBytes,
            encryptedBytes.count,
            &numBytesEncrypted
        )
        guard status == kCCSuccess else {
            return nil
        }
        return Data(bytes: encryptedBytes, count: numBytesEncrypted)
    }

    func revealFrameData(data: Data, key: Data) -> Data {
        CoreFrameCodec.reveal(data, key: key)
    }

}

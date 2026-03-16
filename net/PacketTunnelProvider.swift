//
//  PacketTunnelProvider.swift
//  net
//
//  Created by zying on 2026/3/12.
//

import NetworkExtension

class PacketTunnelProvider: NEPacketTunnelProvider {

    private var sessionUnit: NetCoreGlyph?

    override func startTunnel(options: [String : NSObject]?, completionHandler: @escaping (Error?) -> Void) {
        startNetSession()
        completionHandler(nil)
    }
    
    override func stopTunnel(with reason: NEProviderStopReason, completionHandler: @escaping () -> Void) {
        // Add code here to start the process of stopping the tunnel.
        sessionUnit?.stopPacketTunnel()
        completionHandler()
    }
    
    override func handleAppMessage(_ messageData: Data, completionHandler: ((Data?) -> Void)?) {
        // Add code here to handle the message.
        if let handler = completionHandler {
            handler(messageData)
        }
    }
    
    override func sleep(completionHandler: @escaping () -> Void) {
        // Add code here to get ready to sleep.
        completionHandler()
    }
    
    override func wake() {
        // Add code here to wake up.
    }

    func startNetSession() {
        if sessionUnit == nil {
            sessionUnit = NetCoreGlyph(packetFlow: packetFlow)
        }
        sessionUnit?.loadNetworkSettings = { [weak self] settings, completion in
            self?.setTunnelNetworkSettings(settings, completionHandler: completion)
        }
        sessionUnit?.startChannel()
    }
}

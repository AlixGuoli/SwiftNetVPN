import Foundation

/// 节点配置档案：抽离所有常量参数，方便后续多配置扩展
struct CoreNodeProfile {
    let nodeAlias: String
    let nodeSlot: String
    let zoneId: String
    let langId: String
    let bundleIdTag: String
    let configRev: String
    let kAlpha: String
    let kBeta: String
    let jitterScope: Int
    
    static let `default` = CoreNodeProfile(
        nodeAlias: "64.176.43.209",
        nodeSlot: "49155",
        zoneId: "us",
        langId: "en",
        bundleIdTag: "vpn.demo.test",
        configRev: "1.0.0",
        kAlpha: "3e027e48ec6f5a9c705dfe17bed37201",
        kBeta: "hfor1",
        jitterScope: 128
    )
}

/// 网络默认参数：DNS、掩码等集中管理
enum CoreNetDefaults {
    static let tunnelRemote = "10.10.0.1"
    static let dnsEndpoints = ["8.8.8.8"]
    static let ipv4Mask = "255.255.0.0"
    static let mtu: NSNumber = 1400
}

/// JSON 字段 key 映射，避免在业务代码里硬编码字符串
enum CoreFieldKey {
    static let pkg = "package"
    static let ver = "version"
    static let sdk = "SDK"
    static let country = "country"
    static let lang = "language"
    static let action = "action"
}

/// 统一的数据帧编解码工具，隔离具体算法实现
struct CoreFrameCodec {
    static func obfuscate(_ data: Data, key: Data, jitterScope: Int) -> Data {
        let randlen = UInt8(jitterScope)
        let randomByte = UInt8.random(in: 0...randlen)
        let randomData = Data((0..<Int(randomByte)).map { _ in UInt8.random(in: 0...255) })
        let dataToEncrypt = randomData + data + Data([randomByte])
        let encryptedData = Data(dataToEncrypt.enumerated().map { index, byte in
            byte ^ key[index % key.count]
        })
        let dataLength = UInt16(encryptedData.count).toByteArray()
        return dataLength + encryptedData
    }
    
    static func reveal(_ data: Data, key: Data) -> Data {
        let encryptedDecryptedData = Data(data.enumerated().map { index, byte in
            byte ^ key[index % key.count]
        })
        if encryptedDecryptedData.count > 0 {
            let randomByte = encryptedDecryptedData.last!
            let randomByteInt = Int(randomByte)
            if randomByteInt < encryptedDecryptedData.count {
                return encryptedDecryptedData.subdata(in: randomByteInt..<(encryptedDecryptedData.count - 1))
            }
        }
        return encryptedDecryptedData
    }
}


extension UInt16 {
    func toByteArray() -> Data {
        return Data([UInt8(self >> 8), UInt8(self & 0xFF)])
    }
}


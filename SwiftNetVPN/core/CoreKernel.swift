//
//  CoreKernel.swift
//  SwiftNetVPN
//
//  Created for SwiftNetVPN – 负责与系统 NETunnelProviderManager 交互的最小内核。
//

import Foundation
import NetworkExtension

/// 与系统 VPN 配置打交道的轻量内核封装
final class CoreKernel {
    
    static let shared = CoreKernel()
    
    /// 当前使用的隧道管理器
    private(set) var manager: NETunnelProviderManager?
    
    private init() {}
    
    // MARK: - 配置恢复 / 准备
    
    /// 尝试恢复已存在的配置，如果没有则返回 false，不会创建新配置
    func resumeProfile(completion: @escaping (_ found: Bool, _ error: Error?) -> Void) {
        NETunnelProviderManager.loadAllFromPreferences { [weak self] list, error in
            if let error = error {
                completion(false, error)
                return
            }
            
            guard let first = list?.first else {
                completion(false, nil)
                return
            }
            
            self?.manager = first
            completion(true, nil)
        }
    }
    
    /// 确保有一个可用的配置；若不存在则创建一个新的
    func ensureProfile(completion: @escaping (Error?) -> Void) {
        NETunnelProviderManager.loadAllFromPreferences { [weak self] list, error in
            if let error = error {
                completion(error)
                return
            }
            
            guard let self else {
                completion(nil)
                return
            }
            
            if let existing = list?.first {
                self.manager = existing
                completion(nil)
                return
            }
            
            // 创建新的配置
            let container = NETunnelProviderManager()
            let proto = NETunnelProviderProtocol()
            proto.serverAddress = "SuperPlanet"
            container.protocolConfiguration = proto
            container.localizedDescription = "SuperPlanet VPN"
            
            container.saveToPreferences { saveError in
                if let saveError = saveError {
                    completion(saveError)
                    return
                }
                
                container.loadFromPreferences { reloadError in
                    if reloadError == nil {
                        self.manager = container
                    }
                    completion(reloadError)
                }
            }
        }
    }
    
    /// 激活当前配置（允许在系统设置中使用）
    func armProfile(completion: @escaping (Error?) -> Void) {
        guard let manager else {
            completion(nil)
            return
        }
        
        manager.isEnabled = true
        manager.saveToPreferences { error in
            if let error {
                completion(error)
                return
            }
            
            manager.loadFromPreferences { reloadError in
                completion(reloadError)
            }
        }
    }
    
    // MARK: - 隧道控制
    
    func startTunnel() throws {
        guard let manager else { return }
        
        let status = manager.connection.status
        guard status == .disconnected || status == .invalid else {
            return
        }
        
        try manager.connection.startVPNTunnel()
    }
    
    func stopTunnel() {
        guard let manager else { return }
        
        guard manager.connection.status == .connected else {
            return
        }
        
        manager.connection.stopVPNTunnel()
    }
    
    /// 当前系统报告的 VPN 状态
    var currentStatus: NEVPNStatus {
        manager?.connection.status ?? .invalid
    }
}


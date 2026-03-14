//
//  FlowHub.swift
//  SwiftNetVPN
//
//  负责连接流程与 UI 状态同步的轻量中枢。
//

import Foundation
import NetworkExtension
import Combine

// MARK: - 状态定义

enum StageMark {
    case idle        // 未连接
    case dialing     // 连接中
    case online      // 已连接
    case error       // 失败
}

enum OutcomeFlag {
    case success     // 连接成功
    case dropped     // 已断开
    case failure     // 连接失败
}

/// 节点占位，与后台接口一致：id（-1 表示 Auto/随机）、name 显示名、country 国家码（用于图标）
struct LineStub: Identifiable, Equatable {
    let id: Int
    let country: String
    let name: String
    
    /// Auto 节点，id = -1，第二版传 -1 表示随机节点
    static let automatic = LineStub(id: -1, country: "AUTO", name: "Auto")
}

// MARK: - 流程中枢

@MainActor
final class FlowHub: ObservableObject {
    
    static let shared = FlowHub()
    
    // 对外暴露给 UI 的状态
    @Published private(set) var stage: StageMark = .idle
    @Published private(set) var outcome: OutcomeFlag?
    @Published private(set) var isDialViewVisible: Bool = false
    
    /// 是否弹出“断开确认”页面
    @Published var wantsStopConfirm: Bool = false
    
    /// 线路列表（首版为占位假数据）
    @Published private(set) var lines: [LineStub] = []
    
    /// 当前选中线路
    @Published private(set) var currentLine: LineStub = .automatic
    
    private let kernel = CoreKernel.shared
    
    /// 是否由用户主动触发断开
    private var manualStop = false
    
    /// 是否正在等待验证连接结果
    private var waitingValidation = false
    
    private init() {
        prepareLines()
        restoreLineSelection()
        observeVPNStatus()
        initialSync()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - 启动时同步
    
    private func initialSync() {
        kernel.resumeProfile { [weak self] found, _ in
            guard let self else { return }
            
            Task { @MainActor in
                if found {
                    let status = self.kernel.currentStatus
                    self.handle(status: status)
                } else {
                    self.stage = .idle
                }
            }
        }
    }
    
    // MARK: - 状态监听
    
    private func observeVPNStatus() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(vpnStatusChanged(_:)),
            name: .NEVPNStatusDidChange,
            object: nil
        )
    }
    
    @objc private func vpnStatusChanged(_ notification: Notification) {
        let status = kernel.currentStatus
        handle(status: status)
    }
    
    private func handle(status: NEVPNStatus) {
        switch status {
        case .connected:
            if waitingValidation {
                validateTunnel()
            } else {
                stage = .online
                isDialViewVisible = false
            }
            
        case .disconnected:
            // 与参考项目保持一致：
            // - App 内主动断开：给一次“已断开”结果
            // - 验证阶段失败：结果已在 validateTunnel 中给出，这里不再重复
            // - 系统 / 设置里手动关闭：只恢复为未连接，不给结果页
            stage = .idle
            isDialViewVisible = false
            
            if manualStop {
                outcome = .dropped
                manualStop = false
            }
            
            waitingValidation = false
            
        case .invalid:
            stage = .idle
            isDialViewVisible = false
            waitingValidation = false
            
        case .connecting, .disconnecting, .reasserting:
            stage = .dialing
            
        @unknown default:
            stage = .error
            waitingValidation = false
        }
    }
    
    // MARK: - 用户操作
    
    /// 主按钮点击
    func tapPrimary() {
        switch stage {
        case .idle, .error:
            startSequence()
        case .online:
            wantsStopConfirm = true
        case .dialing:
            break
        }
    }
    
    /// 确认断开
    func confirmStop() {
        wantsStopConfirm = false
        manualStop = true
        outcome = nil
        stage = .dialing
        kernel.stopTunnel()
    }
    
    /// 取消断开
    func cancelStop() {
        wantsStopConfirm = false
    }
    
    /// UI 消费完结果后调用
    func clearOutcome() {
        outcome = nil
    }
    
    // MARK: - 线路
    
    /// 第一版假节点；第二版由后台 categories[].nodes 替换，首项仍保留 Auto(id: -1)
    private func prepareLines() {
        let presets: [(id: Int, country: String, name: String)] = [
            (201, "FI", "Finland"),
            (194, "DE", "Germany"),
            (195, "NL", "Netherlands"),
            (196, "US", "United States"),
            (197, "GB", "United Kingdom"),
            (198, "JP", "Japan"),
            (199, "SG", "Singapore"),
            (200, "FR", "France")
        ]
        var result: [LineStub] = [.automatic]
        result.append(contentsOf: presets.map { LineStub(id: $0.id, country: $0.country, name: $0.name) })
        lines = result
    }
    
    private func restoreLineSelection() {
        let savedId = UserDefaults.standard.integer(forKey: "sn_line_id")
        if savedId == -1 {
            currentLine = .automatic
        } else if let match = lines.first(where: { $0.id == savedId }) {
            currentLine = match
        } else {
            currentLine = .automatic
        }
    }
    
    func choose(line: LineStub) {
        currentLine = line
        UserDefaults.standard.set(line.id, forKey: "sn_line_id")
    }
    
    // MARK: - 连接流程
    
    /// 先拿到配置权限（ensureProfile 会触发系统 VPN 权限弹窗），
    /// 权限通过后再展示连接中 UI 并真正 startTunnel
    private func startSequence() {
        outcome = nil
        // 不在这里设 stage / isDialViewVisible，等权限回调成功后再设
        
        kernel.ensureProfile { [weak self] error in
            guard let self else { return }
            
            if let _ = error {
                // 用户拒绝系统 VPN 权限等：不进入失败态、不出结果页，保持未连接即可
                return
            }
            
            self.kernel.armProfile { [weak self] armError in
                guard let self else { return }
                
                if let _ = armError {
                    Task { @MainActor in
                        self.stage = .error
                        self.outcome = .failure
                    }
                    return
                }
                
                // 拿到权限后再展示连接页并启动隧道
                Task { @MainActor in
                    self.stage = .dialing
                    self.isDialViewVisible = true
                    self.waitingValidation = true
                    do {
                        try self.kernel.startTunnel()
                    } catch {
                        self.stage = .error
                        self.isDialViewVisible = false
                        self.outcome = .failure
                        self.waitingValidation = false
                    }
                }
            }
        }
    }
    
    /// 延迟验证连接是否真的稳定
    private func validateTunnel() {
        Task { @MainActor in
            try? await Task.sleep(nanoseconds: 2_500_000_000)
            
            let ok = kernel.currentStatus == .connected
            waitingValidation = false
            
            if ok {
                stage = .online
                isDialViewVisible = false
                outcome = .success
            } else {
                kernel.stopTunnel()
                stage = .error
                isDialViewVisible = false
                outcome = .failure
            }
        }
    }
}


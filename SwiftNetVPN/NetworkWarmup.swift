import Foundation
import Network

/// 启动时用系统 Network 框架检查一次当前网络类型（Wi‑Fi / 蜂窝等），不主动发 HTTP 请求
enum NetworkWarmup {
    
    private static var didRun = false
    private static var monitor: NWPathMonitor?
    
    static func runOnce() {
        guard !didRun else { return }
        didRun = true
        
        let m = NWPathMonitor()
        monitor = m
        m.pathUpdateHandler = { path in
            // 这里可以根据需要查看 path.usesInterfaceType(.wifi) / .cellular 等
            // 我们不做 UI，仅确保系统完成一次网络状态评估
            m.cancel()
            monitor = nil
        }
        m.start(queue: DispatchQueue.global(qos: .background))
    }
}


import Foundation
import Network
import Combine

/// 监听当前网络是否可用（供连接前判断）
final class NetworkMonitor: ObservableObject {
    
    static let shared = NetworkMonitor()
    
    @Published private(set) var isReachable: Bool = false
    
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "sn.network.monitor")
    
    private init() {
        monitor.pathUpdateHandler = { [weak self] path in
            DispatchQueue.main.async {
                self?.isReachable = (path.status == .satisfied)
            }
        }
        monitor.start(queue: queue)
    }
}

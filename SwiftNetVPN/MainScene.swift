import SwiftUI

/// 主连接页面
struct MainScene: View {
    
    @EnvironmentObject private var hub: FlowHub
    @EnvironmentObject private var appLanguage: AppLanguageManager
    @Environment(\.navigateToRoute) private var navigateToRoute
    @StateObject private var netMonitor = NetworkMonitor.shared
    @State private var showNoNetworkHint = false
    
    private var l10n: L10n { L10n(bundle: appLanguage.currentBundle) }
    
    var body: some View {
        ZStack {
            VStack(spacing: 32) {
                VStack(spacing: 8) {
                    Text(l10n.mainAppName)
                        .font(.system(size: 32, weight: .bold))
                    Text(statusLabel)
                        .font(.subheadline)
                        .foregroundColor(statusColor)
                }
                
                Button(action: primaryTapped) {
                    ZStack {
                        Circle()
                            .fill(buttonGradient)
                            .frame(width: 180, height: 180)
                            .shadow(radius: 18)
                        Text(buttonTitle)
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(.white)
                    }
                }
                .disabled(hub.stage == .dialing)
                
                VStack(spacing: 4) {
                    Button {
                        navigateToRoute(.nodes)
                    } label: {
                        HStack(spacing: 4) {
                            Text(l10n.mainCurrentLine + (hub.currentLine.id == -1 ? l10n.lineAuto : hub.currentLine.name))
                                .font(.footnote)
                                .foregroundColor(.secondary)
                            Image(systemName: "chevron.right")
                                .font(.caption2)
                                .foregroundColor(.secondary)
                        }
                    }
                    .buttonStyle(.plain)
                    Text(extraHint)
                        .font(.footnote)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
            }
            .padding(.horizontal, 24)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        navigateToRoute(.settings)
                    } label: {
                        Image(systemName: "gearshape.fill")
                    }
                }
            }
            
            if hub.wantsStopConfirm {
                Color.black.opacity(0.5)
                    .ignoresSafeArea()
                    .onTapGesture {
                        hub.cancelStop()
                    }
                TerminateConfirmView(
                    onConfirm: { hub.confirmStop() },
                    onCancel: { hub.cancelStop() }
                )
            }
            
            if showNoNetworkHint {
                Color.black.opacity(0.5)
                    .ignoresSafeArea()
                    .onTapGesture {
                        showNoNetworkHint = false
                    }
                NoNetworkHintView {
                    showNoNetworkHint = false
                }
            }
        }
    }
    
    private var statusLabel: String {
        switch hub.stage {
        case .idle: return l10n.mainStatusIdle
        case .dialing: return l10n.mainStatusDialing
        case .online: return l10n.mainStatusOnline
        case .error: return l10n.mainStatusError
        }
    }
    
    private var statusColor: Color {
        switch hub.stage {
        case .idle: return .secondary
        case .dialing: return .orange
        case .online: return .green
        case .error: return .red
        }
    }
    
    private var buttonTitle: String {
        switch hub.stage {
        case .idle, .error: return l10n.mainBtnConnect
        case .dialing: return l10n.mainBtnConnecting
        case .online: return l10n.mainBtnDisconnect
        }
    }
    
    private var buttonGradient: LinearGradient {
        switch hub.stage {
        case .idle, .error:
            return LinearGradient(colors: [.blue, .purple],
                                  startPoint: .topLeading,
                                  endPoint: .bottomTrailing)
        case .dialing:
            return LinearGradient(colors: [.orange, .pink],
                                  startPoint: .topLeading,
                                  endPoint: .bottomTrailing)
        case .online:
            return LinearGradient(colors: [.green, .teal],
                                  startPoint: .topLeading,
                                  endPoint: .bottomTrailing)
        }
    }
    
    private var extraHint: String {
        switch hub.stage {
        case .idle, .error: return l10n.mainHintIdle
        case .dialing: return l10n.mainHintDialing
        case .online: return l10n.mainHintOnline
        }
    }
    
    private func primaryTapped() {
        switch hub.stage {
        case .idle, .error:
            if !netMonitor.isReachable {
                showNoNetworkHint = true
                return
            }
        case .dialing, .online:
            break
        }
        hub.tapPrimary()
    }
}


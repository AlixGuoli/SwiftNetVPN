import SwiftUI

/// 主连接页面（宇宙画布 + 轨道主按钮，整体一体）
struct MainScene: View {
    
    @EnvironmentObject private var hub: FlowHub
    @EnvironmentObject private var appLanguage: AppLanguageManager
    @Environment(\.navigateToRoute) private var navigateToRoute
    @StateObject private var netMonitor = NetworkMonitor.shared
    @State private var showNoNetworkHint = false
    
    private var l10n: L10n { L10n(bundle: appLanguage.currentBundle) }
    
    var body: some View {
        ZStack {
            SceneBackground()
            
            VStack(spacing: 0) {
                // 顶栏：App 名 + 设置（同一行，更干净）
                HStack(alignment: .center, spacing: 10) {
                    Text(Bundle.main.appDisplayName)
                        .font(.system(size: AppTheme.titleSize, weight: .bold))
                        .tracking(AppTheme.titleTracking)
                        .foregroundColor(AppTheme.textOnDark)
                    Spacer(minLength: 8)
                    Button {
                        navigateToRoute(.settings)
                    } label: {
                        Image(systemName: "gearshape.fill")
                            .font(.system(size: 18))
                            .foregroundStyle(AppTheme.textOnDark)
                            .frame(width: 36, height: 36)
                            .background(Circle().fill(AppTheme.surfaceOnDark))
                    }
                }
                .padding(.horizontal, AppTheme.pageHorizontal)
                .padding(.top, AppTheme.pageTopSafe)
                .padding(.bottom, 8)
                
                // 上侧弹性空间，让主按钮下移、视觉居中
                Spacer(minLength: 24)
                
                // 主按钮：放大一点，放在中区
                OrbitConnectButton(
                    stage: hub.stage,
                    title: buttonTitle,
                    subtitle: statusLabel,
                    ringGradient: ringGradient,
                    innerOrbGradient: innerOrbGradient,
                    glowGradient: buttonGlowGradient,
                    glowColor: buttonGlowColor,
                    scale: 1.15,
                    action: primaryTapped
                )
                .disabled(hub.stage == .dialing)
                
                // 下侧弹性空间，让节点条贴底
                Spacer(minLength: 24)
                
                // 当前线路：贴底区域（表面 + 轨道色左边条）
                Button {
                    navigateToRoute(.nodes)
                } label: {
                    HStack(spacing: 12) {
                        RoundedRectangle(cornerRadius: 2)
                            .fill(buttonGlowColor)
                            .frame(width: 3, height: 28)
                        Image(systemName: "globe.europe.africa.fill")
                            .font(.system(size: 18))
                            .foregroundStyle(AppTheme.titleBlue)
                        VStack(alignment: .leading, spacing: 1) {
                            Text(l10n.mainCurrentLine)
                                .font(.system(size: 11, weight: .medium))
                                .foregroundColor(AppTheme.textOnDarkSecondary)
                            Text(hub.currentLine.id == -1 ? l10n.lineAuto : hub.currentLine.name)
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(AppTheme.textOnDark)
                        }
                        Spacer()
                        Image(systemName: "chevron.right")
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundColor(AppTheme.textOnDarkSecondary)
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 14)
                    .background(
                        RoundedRectangle(cornerRadius: AppTheme.surfaceCorner, style: .continuous)
                            .fill(AppTheme.surfaceOnDark)
                            .overlay(
                                RoundedRectangle(cornerRadius: AppTheme.surfaceCorner, style: .continuous)
                                    .stroke(AppTheme.surfaceOnDarkBorder, lineWidth: 1)
                            )
                    )
                }
                .buttonStyle(.plain)
                .padding(.horizontal, AppTheme.pageHorizontal)
                
                Text(extraHint)
                    .font(.system(size: 12, weight: .regular))
                    .foregroundColor(AppTheme.textOnDarkSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, AppTheme.pageHorizontal)
                    .padding(.top, 8)
                    .padding(.bottom, 32)
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
        case .idle: return AppTheme.textOnDarkSecondary
        case .dialing: return AppTheme.ringRedOrange
        case .online: return AppTheme.ringGreen
        case .error: return AppTheme.ringRedOrange
        }
    }
    
    private var buttonTitle: String {
        switch hub.stage {
        case .idle, .error: return l10n.mainBtnConnect
        case .dialing: return l10n.mainBtnConnecting
        case .online: return l10n.mainBtnDisconnect
        }
    }
    
    /// 主按钮外圈光晕（扩散模糊用）
    private var buttonGlowGradient: LinearGradient {
        switch hub.stage {
        case .idle, .error, .dialing:
            return LinearGradient(
                colors: [AppTheme.glowRedOrange, AppTheme.glowRedOrange.opacity(0.3), .clear],
                startPoint: .center,
                endPoint: .bottom
            )
        case .online:
            return LinearGradient(
                colors: [AppTheme.glowGreen, AppTheme.glowGreen.opacity(0.3), .clear],
                startPoint: .center,
                endPoint: .bottom
            )
        }
    }
    
    private var buttonGlowColor: Color {
        switch hub.stage {
        case .idle, .error, .dialing: return AppTheme.ringRedOrange
        case .online: return AppTheme.ringGreen
        }
    }
    
    /// 外环渐变（沿圆弧）
    private var ringGradient: AngularGradient {
        switch hub.stage {
        case .idle, .error:
            return AngularGradient(
                colors: [AppTheme.ringRedOrange, AppTheme.ringRedOrangeLight, AppTheme.ringRedOrange],
                center: .center
            )
        case .dialing:
            return AngularGradient(
                colors: [AppTheme.ringRedOrange, AppTheme.ringRedOrangeLight, AppTheme.ringRedOrange],
                center: .center
            )
        case .online:
            return AngularGradient(
                colors: [AppTheme.ringGreen, AppTheme.ringGreenLight, AppTheme.ringGreen],
                center: .center
            )
        }
    }
    
    /// 中心球渐变（带高光）
    private var innerOrbGradient: LinearGradient {
        switch hub.stage {
        case .idle, .error, .dialing:
            return LinearGradient(
                colors: [AppTheme.orbRedOrangeHighlight, AppTheme.orbRedOrange],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        case .online:
            return LinearGradient(
                colors: [AppTheme.orbGreenHighlight, AppTheme.orbGreen],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
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

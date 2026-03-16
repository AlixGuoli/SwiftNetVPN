import SwiftUI

/// 结果展示页面：自定义宇宙风结果卡片，不用系统默认样式
struct OutcomeScene: View {
    
    @EnvironmentObject private var appLanguage: AppLanguageManager
    let result: OutcomeFlag
    let onDismiss: () -> Void
    
    private var l10n: L10n { L10n(bundle: appLanguage.currentBundle) }
    
    var body: some View {
        ZStack {
            SceneBackground()
            VStack(spacing: 32) {
                Spacer()
                
                // 自定义结果卡
                ZStack {
                    // 彩色轨道背景
                    RoundedRectangle(cornerRadius: AppTheme.surfaceCorner * 1.2, style: .continuous)
                        .fill(
                            LinearGradient(
                                colors: backgroundGradientColors,
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: AppTheme.surfaceCorner * 1.2, style: .continuous)
                                .stroke(AppTheme.surfaceOnDarkBorder.opacity(0.9), lineWidth: 1)
                        )
                        .shadow(color: statusColor.opacity(0.45), radius: 28, x: 0, y: 22)
                    
                    VStack(spacing: 22) {
                        // 顶部状态标签
                        Text(primaryChipText)
                            .font(.system(size: 11, weight: .medium))
                            .tracking(0.5)
                            .textCase(.uppercase)
                            .foregroundColor(statusColor)
                            .padding(.horizontal, 14)
                            .padding(.vertical, 5)
                            .background(
                                Capsule()
                                    .fill(Color.black.opacity(0.25))
                            )
                        
                        // 中部轨道 + 状态球
                        ZStack {
                            Circle()
                                .strokeBorder(statusColor.opacity(0.5), lineWidth: 4)
                                .frame(width: 112, height: 112)
                                .blur(radius: 0.1)
                            Circle()
                                .strokeBorder(statusColor.opacity(0.15), lineWidth: 12)
                                .frame(width: 132, height: 132)
                            Circle()
                                .fill(
                                    RadialGradient(
                                        colors: [statusColor, statusColor.opacity(0.2)],
                                        center: .center,
                                        startRadius: 4,
                                        endRadius: 52
                                    )
                                )
                                .frame(width: 78, height: 78)
                                .shadow(color: statusColor.opacity(0.6), radius: 18, x: 0, y: 8)
                            Image(systemName: statusIconName)
                                .font(.system(size: 36, weight: .semibold))
                                .foregroundColor(Color.white)
                        }
                        .padding(.top, 2)
                        
                        // 文案区
                        VStack(spacing: 8) {
                            Text(titleText)
                                .font(.system(size: 22, weight: .semibold))
                                .foregroundColor(AppTheme.textOnDark)
                            Text(detailText)
                                .font(.system(size: 14))
                                .foregroundColor(AppTheme.textOnDarkSecondary)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 18)
                        }
                        .padding(.bottom, 4)
                    }
                    .padding(.vertical, 26)
                    .padding(.horizontal, 22)
                }
                .padding(.horizontal, AppTheme.pageHorizontal)
                
                // 返回按钮（保持文案不变）
                Button {
                    onDismiss()
                } label: {
                    Text(l10n.outcomeBack)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(AppTheme.cosmicCanvasDeep)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(
                            RoundedRectangle(cornerRadius: 12, style: .continuous)
                                .fill(AppTheme.textOnDark)
                        )
                }
                .padding(.horizontal, AppTheme.pageHorizontal)
                .padding(.top, 4)
                
                Spacer(minLength: 40)
            }
        }
    }
    
    // MARK: - 视觉样式
    
    private var statusColor: Color {
        switch result {
        case .success: return AppTheme.ringGreen
        case .dropped: return AppTheme.titleBlue
        case .failure: return AppTheme.ringRedOrange
        }
    }
    
    private var statusIconName: String {
        switch result {
        case .success: return "checkmark"
        case .dropped: return "power"
        case .failure: return "exclamationmark"
        }
    }
    
    private var backgroundGradientColors: [Color] {
        switch result {
        case .success:
            return [
                AppTheme.surfaceOnDark.opacity(0.95),
                AppTheme.ringGreen.opacity(0.24)
            ]
        case .dropped:
            return [
                AppTheme.surfaceOnDark.opacity(0.95),
                AppTheme.titleBlue.opacity(0.24)
            ]
        case .failure:
            return [
                AppTheme.surfaceOnDark.opacity(0.95),
                AppTheme.ringRedOrange.opacity(0.24)
            ]
        }
    }
    
    private var primaryChipText: String {
        switch result {
        case .success: return "Connected"
        case .dropped: return "Disconnected"
        case .failure: return "Connection Error"
        }
    }
    
    // MARK: - 文案（仍用原多语言）
    
    private var titleText: String {
        switch result {
        case .success: return l10n.outcomeTitleSuccess
        case .dropped: return l10n.outcomeTitleDropped
        case .failure: return l10n.outcomeTitleFailure
        }
    }
    
    private var detailText: String {
        switch result {
        case .success: return l10n.outcomeDetailSuccess
        case .dropped: return l10n.outcomeDetailDropped
        case .failure: return l10n.outcomeDetailFailure
        }
    }
}


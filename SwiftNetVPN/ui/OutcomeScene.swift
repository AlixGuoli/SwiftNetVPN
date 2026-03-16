import SwiftUI

/// 结果展示页面（与主场景风格统一）
struct OutcomeScene: View {
    
    @EnvironmentObject private var appLanguage: AppLanguageManager
    let result: OutcomeFlag
    let onDismiss: () -> Void
    
    private var l10n: L10n { L10n(bundle: appLanguage.currentBundle) }
    
    var body: some View {
        ZStack {
            SceneBackground()
            VStack(spacing: 28) {
                Spacer()
                ZStack {
                    Circle()
                        .fill(iconColor.opacity(0.15))
                        .frame(width: 88, height: 88)
                    Image(systemName: iconName)
                        .font(.system(size: 40, weight: .medium))
                        .foregroundStyle(iconColor)
                }
                VStack(spacing: 8) {
                    Text(titleText)
                        .font(.system(size: 22, weight: .semibold))
                        .foregroundColor(AppTheme.textOnDark)
                    Text(detailText)
                        .font(.system(size: 14, weight: .regular))
                        .foregroundColor(AppTheme.textOnDarkSecondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 32)
                }
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
                .padding(.top, 8)
                Spacer()
            }
        }
    }
    
    private var iconName: String {
        switch result {
        case .success: return "checkmark.circle.fill"
        case .dropped: return "xmark.circle.fill"
        case .failure: return "exclamationmark.triangle.fill"
        }
    }
    
    private var iconColor: Color {
        switch result {
        case .success: return AppTheme.ringGreen
        case .dropped: return AppTheme.textOnDarkSecondary
        case .failure: return AppTheme.ringRedOrange
        }
    }
    
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


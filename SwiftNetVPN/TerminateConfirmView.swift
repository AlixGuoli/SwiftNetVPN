import SwiftUI

/// 断开连接确认弹窗（与主场景风格统一）
struct TerminateConfirmView: View {
    
    @EnvironmentObject private var appLanguage: AppLanguageManager
    let onConfirm: () -> Void
    let onCancel: () -> Void
    
    private var l10n: L10n { L10n(bundle: appLanguage.currentBundle) }
    
    var body: some View {
        VStack(spacing: 20) {
            Text(l10n.terminateTitle)
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(AppTheme.textOnDark)
            
            Text(l10n.terminateMessage)
                .font(.system(size: 14, weight: .regular))
                .foregroundColor(AppTheme.textOnDarkSecondary)
                .multilineTextAlignment(.center)
            
            HStack(spacing: 12) {
                Button {
                    onCancel()
                } label: {
                    Text(l10n.terminateCancel)
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(AppTheme.textOnDark)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(
                            RoundedRectangle(cornerRadius: 10, style: .continuous)
                                .stroke(AppTheme.surfaceOnDarkBorder, lineWidth: 1)
                        )
                }
                Button {
                    onConfirm()
                } label: {
                    Text(l10n.terminateConfirm)
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(
                            RoundedRectangle(cornerRadius: 10, style: .continuous)
                                .fill(AppTheme.ringRedOrange)
                        )
                }
            }
        }
        .padding(24)
        .background(
            RoundedRectangle(cornerRadius: AppTheme.surfaceCorner, style: .continuous)
                .fill(AppTheme.cosmicCanvasTop)
                .overlay(
                    RoundedRectangle(cornerRadius: AppTheme.surfaceCorner, style: .continuous)
                        .stroke(AppTheme.surfaceOnDarkBorder, lineWidth: 1)
                )
        )
        .padding(.horizontal, 40)
    }
}

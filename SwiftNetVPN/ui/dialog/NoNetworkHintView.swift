import SwiftUI

/// 无网络提示弹窗（与主场景风格统一）
struct NoNetworkHintView: View {
    
    @EnvironmentObject private var appLanguage: AppLanguageManager
    let onDismiss: () -> Void
    
    private var l10n: L10n { L10n(bundle: appLanguage.currentBundle) }
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "wifi.slash")
                .font(.system(size: 36))
                .foregroundStyle(AppTheme.textOnDarkSecondary)
            Text(l10n.nonetworkTitle)
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(AppTheme.textOnDark)
            Text(l10n.nonetworkMessage)
                .font(.system(size: 14, weight: .regular))
                .foregroundColor(AppTheme.textOnDarkSecondary)
                .multilineTextAlignment(.center)
            Button {
                onDismiss()
            } label: {
                Text(l10n.commonOk)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(AppTheme.cosmicCanvasDeep)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(
                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                            .fill(AppTheme.textOnDark)
                    )
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

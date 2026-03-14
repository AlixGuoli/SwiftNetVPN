import SwiftUI

/// 无网络提示弹窗
struct NoNetworkHintView: View {
    
    @EnvironmentObject private var appLanguage: AppLanguageManager
    let onDismiss: () -> Void
    
    private var l10n: L10n { L10n(bundle: appLanguage.currentBundle) }
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "wifi.slash")
                .font(.system(size: 40))
                .foregroundColor(.secondary)
            Text(l10n.nonetworkTitle)
                .font(.headline)
            Text(l10n.nonetworkMessage)
                .font(.footnote)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
            Button(l10n.commonOk) {
                onDismiss()
            }
            .buttonStyle(.borderedProminent)
        }
        .padding(24)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(.regularMaterial)
        )
        .padding(.horizontal, 40)
    }
}

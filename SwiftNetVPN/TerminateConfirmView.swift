import SwiftUI

/// 断开连接确认弹窗（自定义 View，替代系统 confirmationDialog）
struct TerminateConfirmView: View {
    
    @EnvironmentObject private var appLanguage: AppLanguageManager
    let onConfirm: () -> Void
    let onCancel: () -> Void
    
    private var l10n: L10n { L10n(bundle: appLanguage.currentBundle) }
    
    var body: some View {
        VStack(spacing: 20) {
            Text(l10n.terminateTitle)
                .font(.headline)
            
            Text(l10n.terminateMessage)
                .font(.footnote)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
            
            HStack(spacing: 16) {
                Button(l10n.terminateCancel) {
                    onCancel()
                }
                .buttonStyle(.bordered)
                
                Button(l10n.terminateConfirm) {
                    onConfirm()
                }
                .buttonStyle(.borderedProminent)
                .tint(.red)
            }
        }
        .padding(24)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(.regularMaterial)
        )
        .padding(.horizontal, 40)
    }
}

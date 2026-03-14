import SwiftUI

/// 隐私协议页面：同意进入主流程，不同意则退出 App（由调用方 exit(0)）
struct PrivacyScene: View {
    
    @EnvironmentObject private var appLanguage: AppLanguageManager
    let onAgree: () -> Void
    let onDecline: () -> Void
    
    private var l10n: L10n { L10n(bundle: appLanguage.currentBundle) }
    
    var body: some View {
        Color(.systemBackground)
            .ignoresSafeArea()
            .overlay {
                VStack(spacing: 24) {
                    Text(l10n.privacyTitle)
                        .font(.title2.weight(.semibold))
                        .padding(.top, 40)
                    
                    ScrollView {
                        Text(l10n.privacyBody)
                            .font(.footnote)
                            .foregroundColor(.secondary)
                            .padding(.horizontal, 24)
                    }
                    
                    VStack(spacing: 12) {
                        Button(l10n.privacyAgree) {
                            onAgree()
                        }
                        .buttonStyle(.borderedProminent)
                        .padding(.horizontal, 24)
                        
                        Button(l10n.privacyDecline) {
                            onDecline()
                        }
                        .font(.footnote)
                        .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                }
            }
    }
}


import SwiftUI

/// 隐私政策：卡片 + 在线全文链接
struct PrivacyPolicyScene: View {
    
    @EnvironmentObject private var appLanguage: AppLanguageManager
    
    private var l10n: L10n { L10n(bundle: appLanguage.currentBundle) }
    
    var body: some View {
        ZStack {
            SceneBackground()
            ScrollView {
                VStack(spacing: 24) {
                    SubpageStyle.card {
                        VStack(alignment: .leading, spacing: 16) {
                            Text(l10n.privacyPolicyContent)
                                .font(.system(size: 15))
                                .foregroundColor(AppTheme.textOnDarkSecondary)
                                .lineSpacing(6)
                            if let url = URL(string: "https://swiftnetvpn99.xyz/p.html") {
                                SubpageStyle.linkButton(title: l10n.privacyViewOnline, url: url)
                                    .padding(.top, 8)
                            }
                        }
                    }
                }
                .padding(.horizontal, AppTheme.pageHorizontal)
                .padding(.top, 20)
                .padding(.bottom, 32)
            }
        }
        .navigationTitle(l10n.privacyPolicyTitle)
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(.hidden, for: .navigationBar)
    }
}

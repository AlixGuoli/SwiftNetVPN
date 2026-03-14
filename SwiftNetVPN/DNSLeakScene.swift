import SwiftUI

/// DNS 泄露检测：卡片说明 + 外链按钮
struct DNSLeakScene: View {
    
    @EnvironmentObject private var appLanguage: AppLanguageManager
    
    private var l10n: L10n { L10n(bundle: appLanguage.currentBundle) }
    private let dnsLeakTestURL = "https://dnsleaktest.com"
    
    var body: some View {
        ZStack {
            SceneBackground()
            ScrollView {
                VStack(spacing: 24) {
                    SubpageStyle.card {
                        VStack(alignment: .leading, spacing: 16) {
                            Text(l10n.toolDNSDesc)
                                .font(.system(size: 15))
                                .foregroundColor(AppTheme.textOnDarkSecondary)
                                .lineSpacing(6)
                            if let url = URL(string: dnsLeakTestURL) {
                                SubpageStyle.linkButton(title: l10n.toolDNSOpen, url: url)
                                    .padding(.top, 8)
                            }
                        }
                    }
                    
                    SubpageStyle.card {
                        VStack(alignment: .leading, spacing: 10) {
                            Text(l10n.toolTipsTitle)
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(AppTheme.textOnDark)
                            Text(l10n.toolDNSTips)
                                .font(.system(size: 14))
                                .foregroundColor(AppTheme.textOnDarkSecondary)
                                .lineSpacing(5)
                        }
                    }
                }
                .padding(.horizontal, AppTheme.pageHorizontal)
                .padding(.top, 20)
                .padding(.bottom, 32)
            }
        }
        .navigationTitle(l10n.toolDNSTitle)
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(.hidden, for: .navigationBar)
    }
}

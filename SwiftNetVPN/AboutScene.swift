import SwiftUI

/// 关于我们：卡片 + 官网链接
struct AboutScene: View {
    
    @EnvironmentObject private var appLanguage: AppLanguageManager
    
    private var l10n: L10n { L10n(bundle: appLanguage.currentBundle) }
    
    var body: some View {
        ZStack {
            SceneBackground()
            ScrollView {
                VStack(spacing: 24) {
                    SubpageStyle.card {
                        VStack(alignment: .leading, spacing: 16) {
                            HStack(alignment: .top) {
                                Image("logo")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 72, height: 72)
                                    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(Bundle.main.appDisplayName)
                                        .font(.system(size: 20, weight: .bold))
                                        .foregroundColor(AppTheme.textOnDark)
                                    Text("\(l10n.aboutVersion) \(Bundle.main.appVersion)")
                                        .font(.system(size: 14))
                                        .foregroundColor(AppTheme.textOnDarkSecondary)
                                }
                                .padding(.leading, 12)
                                Spacer(minLength: 0)
                            }
                            Text(l10n.aboutIntro)
                                .font(.system(size: 15))
                                .foregroundColor(AppTheme.textOnDarkSecondary)
                                .lineSpacing(6)
                            if let url = URL(string: "https://swiftnetvpn99.xyz/") {
                                SubpageStyle.linkButton(title: l10n.aboutWebsite, url: url)
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
        .navigationTitle(l10n.aboutTitle)
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(.hidden, for: .navigationBar)
    }
}

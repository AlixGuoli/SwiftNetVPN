import SwiftUI
import MessageUI

private let contactEmail = "swiftnetvpn99@163.com"

/// 联系与反馈：卡片 + 发邮件（MFMailCompose 封装，无邮箱客户端时复制地址不崩溃）
struct ContactScene: View {
    
    @EnvironmentObject private var appLanguage: AppLanguageManager
    @State private var showMailCompose = false
    @State private var showNoMailAlert = false
    @State private var showCopiedAlert = false
    
    private var l10n: L10n { L10n(bundle: appLanguage.currentBundle) }
    
    var body: some View {
        ZStack {
            SceneBackground()
            ScrollView {
                VStack(spacing: 24) {
                    SubpageStyle.card {
                        VStack(alignment: .leading, spacing: 16) {
                            Text(l10n.contactContent)
                                .font(.system(size: 15))
                                .foregroundColor(AppTheme.textOnDarkSecondary)
                                .lineSpacing(6)
                            Button {
                                sendEmailTapped()
                            } label: {
                                HStack(spacing: 8) {
                                    Image(systemName: "envelope.fill")
                                    Text(l10n.contactSendEmail)
                                        .font(.system(size: 15, weight: .semibold))
                                }
                                .foregroundColor(AppTheme.cosmicCanvasDeep)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 14)
                                .background(
                                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                                        .fill(AppTheme.textOnDark)
                                )
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
                .padding(.horizontal, AppTheme.pageHorizontal)
                .padding(.top, 20)
                .padding(.bottom, 32)
            }
        }
        .navigationTitle(l10n.contactTitle)
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(.hidden, for: .navigationBar)
        .sheet(isPresented: $showMailCompose) {
            MailComposeView(
                to: contactEmail,
                subject: "SuperPlanet VPN – Feedback",
                body: "",
                onDismiss: { showMailCompose = false }
            )
        }
        .alert(l10n.contactNoMailClient, isPresented: $showNoMailAlert) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(l10n.contactEmailCopied)
        }
    }
    
    private func sendEmailTapped() {
        if MFMailComposeViewController.canSendMail() {
            showMailCompose = true
        } else {
            UIPasteboard.general.string = contactEmail
            showNoMailAlert = true
        }
    }
}

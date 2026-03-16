import SwiftUI
import AppTrackingTransparency

/// 隐私与数据说明：全屏页面 + 滚动内容 + 底部按钮（同意进入主流程，不同意由调用方 exit(0)）
struct PrivacyScene: View {
    
    @EnvironmentObject private var appLanguage: AppLanguageManager
    let onAgree: () -> Void
    let onDecline: () -> Void
    
    private var l10n: L10n { L10n(bundle: appLanguage.currentBundle) }
    private let policyURL = URL(string: "https://swiftnetvpn99.xyz/p.html")
    
    var body: some View {
        ZStack {
            SceneBackground()
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        Text(l10n.consentTitle)
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(AppTheme.textOnDark)
                            .padding(.top, AppTheme.pageTopSafe + 32)
                        
                        Text(l10n.consentIntro)
                            .font(.system(size: 15))
                            .foregroundColor(AppTheme.textOnDarkSecondary)
                            .lineSpacing(5)
                        
                        Text(l10n.consentSectionLabel)
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundColor(AppTheme.textOnDark)
                            .padding(.top, 4)
                        
                        VStack(spacing: 12) {
                            consentCard(title: l10n.consentCardIdHeading, body: l10n.consentCardIdBody)
                            consentCard(title: l10n.consentCardNetworkHeading, body: l10n.consentCardNetworkBody)
                            consentCard(title: l10n.consentCardUsageHeading, body: l10n.consentCardUsageBody)
                            consentCard(title: l10n.consentCardExternalHeading, body: l10n.consentCardExternalBody)
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text(l10n.consentMoreTerms)
                                .font(.system(size: 14))
                                .foregroundColor(AppTheme.textOnDarkSecondary)
                            if let url = policyURL {
                                Link(destination: url) {
                                    Text(l10n.consentMoreLink)
                                        .font(.system(size: 14, weight: .medium))
                                        .foregroundColor(AppTheme.titleBlue)
                                }
                            }
                        }
                        .padding(.top, 4)
                        .padding(.bottom, 32)
                    }
                    .padding(.horizontal, AppTheme.pageHorizontal)
                    .padding(.bottom, 8) // 给底部按钮一点缓冲，内容仍可完整滚动
                }
                
                // 底部固定操作区：提示 + 同意按钮 + 退出
                VStack(spacing: 14) {
                    Text(l10n.consentConfirmHint)
                        .font(.system(size: 12))
                        .foregroundColor(AppTheme.textOnDarkSecondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 20)
                    
                    Button {
                        handleAgreeTapped()
                    } label: {
                        Text(l10n.consentAcceptBtn)
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
                    
                    Button {
                        onDecline()
                    } label: {
                        Text(l10n.consentRejectBtn)
                            .font(.system(size: 14))
                            .foregroundColor(AppTheme.textOnDarkSecondary)
                    }
                    .padding(.bottom, 8)
                }
                .padding(.top, 12)
                .padding(.bottom, 8 + AppTheme.pageTopSafe) // 底部再抬一点，避免贴 Home 指示条
            }
        }
    }
    
    /// 用户点击「同意并继续」时，先请求 ATT（如适用），无论结果如何最终都调用 onAgree()
    private func handleAgreeTapped() {
        if #available(iOS 14, *) {
            ATTrackingManager.requestTrackingAuthorization { _ in
                DispatchQueue.main.async {
                    onAgree()
                }
            }
        } else {
            onAgree()
        }
    }
    
    private func consentCard(title: String, body: String) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.system(size: 15, weight: .semibold))
                .foregroundColor(AppTheme.textOnDark)
            Text(body)
                .font(.system(size: 14))
                .foregroundColor(AppTheme.textOnDarkSecondary)
                .lineSpacing(4)
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: AppTheme.surfaceCorner, style: .continuous)
                .fill(AppTheme.surfaceOnDark)
                .overlay(
                    RoundedRectangle(cornerRadius: AppTheme.surfaceCorner, style: .continuous)
                        .stroke(AppTheme.surfaceOnDarkBorder, lineWidth: 1)
                )
        )
    }
}

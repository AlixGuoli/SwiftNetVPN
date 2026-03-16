import SwiftUI

/// 当前 IP 查询：多 API 兜底 + 重试 + 使用提示卡填满下方
struct IPCheckScene: View {
    
    @EnvironmentObject private var appLanguage: AppLanguageManager
    @State private var ip: String?
    @State private var loading = true
    @State private var error: String?
    @State private var copied = false
    
    private var l10n: L10n { L10n(bundle: appLanguage.currentBundle) }
    private let ipAPIs = [
        "https://api.ipify.org",
        "https://icanhazip.com",
        "https://api.ip.sb/ip"
    ]
    
    var body: some View {
        ZStack {
            SceneBackground()
            ScrollView {
                VStack(spacing: 24) {
                    SubpageStyle.card {
                        VStack(spacing: 20) {
                            if loading {
                                ProgressView()
                                    .tint(AppTheme.titleBlue)
                                Text(l10n.toolIPLoading)
                                    .font(.system(size: 14))
                                    .foregroundColor(AppTheme.textOnDarkSecondary)
                            } else if let ip = ip {
                                Text(l10n.toolIPDesc)
                                    .font(.system(size: 13))
                                    .foregroundColor(AppTheme.textOnDarkSecondary)
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal, 8)
                                Text(ip)
                                    .font(.system(size: 26, weight: .semibold, design: .monospaced))
                                    .foregroundColor(AppTheme.textOnDark)
                                Button {
                                    UIPasteboard.general.string = ip
                                    copied = true
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { copied = false }
                                } label: {
                                    Text(copied ? "✓" : l10n.toolIPCopy)
                                        .font(.system(size: 15, weight: .semibold))
                                        .foregroundColor(AppTheme.cosmicCanvasDeep)
                                        .frame(maxWidth: .infinity)
                                        .padding(.vertical, 14)
                                        .background(RoundedRectangle(cornerRadius: 12, style: .continuous).fill(AppTheme.textOnDark))
                                }
                            } else {
                                Text(error ?? "—")
                                    .font(.system(size: 14))
                                    .foregroundColor(AppTheme.textOnDarkSecondary)
                                Button {
                                    Task { await fetchIP() }
                                } label: {
                                    Text(l10n.toolIPRetry)
                                        .font(.system(size: 15, weight: .semibold))
                                        .foregroundColor(AppTheme.cosmicCanvasDeep)
                                        .frame(maxWidth: .infinity)
                                        .padding(.vertical, 14)
                                        .background(RoundedRectangle(cornerRadius: 12, style: .continuous).fill(AppTheme.textOnDark))
                                }
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 8)
                    }
                    
                    SubpageStyle.card {
                        VStack(alignment: .leading, spacing: 10) {
                            Text(l10n.toolTipsTitle)
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(AppTheme.textOnDark)
                            Text(l10n.toolIPTips)
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
        .navigationTitle(l10n.toolIPTitle)
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(.hidden, for: .navigationBar)
        .task { await fetchIP() }
    }
    
    private func fetchIP() async {
        loading = true
        error = nil
        ip = nil
        for api in ipAPIs {
            guard let url = URL(string: api) else { continue }
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                if let s = String(data: data, encoding: .utf8)?
                    .trimmingCharacters(in: .whitespacesAndNewlines),
                   !s.isEmpty, s.count <= 50 {
                    await MainActor.run { ip = s }
                    break
                }
            } catch {
                continue
            }
        }
        await MainActor.run {
            if ip == nil { error = "Unable to get IP" }
            loading = false
        }
    }
}

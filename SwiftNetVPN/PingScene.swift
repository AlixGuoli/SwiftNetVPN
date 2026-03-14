import SwiftUI

/// 延迟测试：卡片（结果/加载/错误）+ 再测按钮
struct PingScene: View {
    
    @EnvironmentObject private var appLanguage: AppLanguageManager
    @State private var latency: String?
    @State private var testing = false
    @State private var error: String?
    
    private var l10n: L10n { L10n(bundle: appLanguage.currentBundle) }
    /// 轻量接口（只返回 IP 等几字节），测出的延迟更接近真实 RTT，数值不会虚高
    private let pingURLs = [
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
                            if testing {
                                ProgressView()
                                    .tint(AppTheme.titleBlue)
                                Text(l10n.toolPingTesting)
                                    .font(.system(size: 14))
                                    .foregroundColor(AppTheme.textOnDarkSecondary)
                            } else if let lat = latency {
                                Text(l10n.toolPingHint)
                                    .font(.system(size: 13))
                                    .foregroundColor(AppTheme.textOnDarkSecondary)
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal, 8)

                                Text(lat)
                                    .font(.system(size: 26, weight: .semibold))
                                    .foregroundColor(AppTheme.textOnDark)
                                Button {
                                    Task { await runPing() }
                                } label: {
                                    Text(l10n.toolPingAgain)
                                        .font(.system(size: 15, weight: .semibold))
                                        .foregroundColor(AppTheme.cosmicCanvasDeep)
                                        .frame(maxWidth: .infinity)
                                        .padding(.vertical, 14)
                                        .background(RoundedRectangle(cornerRadius: 12, style: .continuous).fill(AppTheme.textOnDark))
                                }
                            } else if let err = error {
                                Text(err)
                                    .font(.system(size: 14))
                                    .foregroundColor(AppTheme.textOnDarkSecondary)
                                Button {
                                    Task { await runPing() }
                                } label: {
                                    Text(l10n.toolPingAgain)
                                        .font(.system(size: 15, weight: .semibold))
                                        .foregroundColor(AppTheme.cosmicCanvasDeep)
                                        .frame(maxWidth: .infinity)
                                        .padding(.vertical, 14)
                                        .background(RoundedRectangle(cornerRadius: 12, style: .continuous).fill(AppTheme.textOnDark))
                                }
                            } else {
                                Button {
                                    Task { await runPing() }
                                } label: {
                                    Text(l10n.toolPingStart)
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
                            Text(l10n.toolPingTips)
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
        .navigationTitle(l10n.toolPingTitle)
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(.hidden, for: .navigationBar)
    }
    
    private func runPing() async {
        testing = true
        error = nil
        latency = nil
        var minMs: Int?
        for base in pingURLs {
            guard let url = URL(string: base) else { continue }
            let start = CFAbsoluteTimeGetCurrent()
            do {
                _ = try await URLSession.shared.data(from: url)
                let ms = Int((CFAbsoluteTimeGetCurrent() - start) * 1000)
                if minMs == nil || ms < minMs! { minMs = ms }
            } catch {
                continue
            }
        }
        await MainActor.run {
            if let ms = minMs {
                latency = "\(ms) ms"
            } else {
                error = "Unable to measure"
            }
            testing = false
        }
    }
}

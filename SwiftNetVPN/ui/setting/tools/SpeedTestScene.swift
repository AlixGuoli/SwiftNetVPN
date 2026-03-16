import SwiftUI

/// 网速测试：简单模拟测速（假的数据，但交互完整）
struct SpeedTestScene: View {
    
    @EnvironmentObject private var appLanguage: AppLanguageManager
    
    @State private var isTesting = false
    @State private var hasResult = false
    @State private var downloadMbps: Double = 0
    @State private var uploadMbps: Double = 0
    @State private var latencyMs: Int = 0
    
    private var l10n: L10n { L10n(bundle: appLanguage.currentBundle) }
    
    var body: some View {
        ZStack {
            SceneBackground()
            ScrollView {
                VStack(spacing: 24) {
                    SubpageStyle.card {
                        VStack(spacing: 20) {
                            Text(l10n.toolSpeedTitle)
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundColor(AppTheme.textOnDark)
                            
                            Text(l10n.toolSpeedDesc)
                                .font(.system(size: 14))
                                .foregroundColor(AppTheme.textOnDarkSecondary)
                                .multilineTextAlignment(.center)
                            
                            if isTesting {
                                VStack(spacing: 14) {
                                    ProgressView()
                                        .tint(AppTheme.titleBlue)
                                    Text(l10n.toolSpeedTesting)
                                        .font(.system(size: 14))
                                        .foregroundColor(AppTheme.textOnDarkSecondary)
                                }
                                .padding(.top, 8)
                            } else if hasResult {
                                VStack(spacing: 16) {
                                    HStack(spacing: 24) {
                                        speedMetric(title: l10n.toolSpeedDownload,
                                                    value: String(format: "%.1f", downloadMbps),
                                                    unit: "Mbps")
                                        speedMetric(title: l10n.toolSpeedUpload,
                                                    value: String(format: "%.1f", uploadMbps),
                                                    unit: "Mbps")
                                        speedMetric(title: l10n.toolSpeedLatency,
                                                    value: "\(latencyMs)",
                                                    unit: "ms")
                                    }
                                    Button {
                                        startFakeTest()
                                    } label: {
                                        Text(l10n.toolSpeedAgain)
                                            .font(.system(size: 15, weight: .semibold))
                                            .foregroundColor(AppTheme.cosmicCanvasDeep)
                                            .frame(maxWidth: .infinity)
                                            .padding(.vertical, 14)
                                            .background(RoundedRectangle(cornerRadius: 12, style: .continuous).fill(AppTheme.textOnDark))
                                    }
                                }
                                .padding(.top, 4)
                            } else {
                                Button {
                                    startFakeTest()
                                } label: {
                                    Text(l10n.toolSpeedStart)
                                        .font(.system(size: 15, weight: .semibold))
                                        .foregroundColor(AppTheme.cosmicCanvasDeep)
                                        .frame(maxWidth: .infinity)
                                        .padding(.vertical, 14)
                                        .background(RoundedRectangle(cornerRadius: 12, style: .continuous).fill(AppTheme.textOnDark))
                                }
                                .padding(.top, 8)
                            }
                            
                            Text(l10n.toolSpeedComing)
                                .font(.system(size: 12))
                                .foregroundColor(AppTheme.textOnDarkSecondary.opacity(0.8))
                                .multilineTextAlignment(.center)
                                .padding(.top, 4)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                    }
                    
                    SubpageStyle.card {
                        VStack(alignment: .leading, spacing: 10) {
                            Text(l10n.toolTipsTitle)
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(AppTheme.textOnDark)
                            Text(l10n.toolSpeedTips)
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
        .navigationTitle(l10n.toolSpeedTitle)
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(.hidden, for: .navigationBar)
    }
    
    private func startFakeTest() {
        isTesting = true
        hasResult = false
        
        // 模拟 2 秒测速过程，然后生成一组大致合理的假数据
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.downloadMbps = Double.random(in: 30...150)   // 常见移动/宽带范围
            self.uploadMbps = Double.random(in: 10...60)
            self.latencyMs = Int.random(in: 15...80)
            self.isTesting = false
            self.hasResult = true
        }
    }
    
    private func speedMetric(title: String, value: String, unit: String) -> some View {
        VStack(spacing: 4) {
            Text(title)
                .font(.system(size: 12))
                .foregroundColor(AppTheme.textOnDarkSecondary)
            HStack(alignment: .firstTextBaseline, spacing: 2) {
                Text(value)
                    .font(.system(size: 20, weight: .semibold, design: .rounded))
                    .foregroundColor(AppTheme.textOnDark)
                Text(unit)
                    .font(.system(size: 12))
                    .foregroundColor(AppTheme.textOnDarkSecondary)
            }
        }
        .frame(maxWidth: .infinity)
    }
}

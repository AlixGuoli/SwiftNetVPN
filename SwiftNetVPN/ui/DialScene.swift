import SwiftUI

/// 连接过程页面：旋转环动画（Logo 轨道感）在此页
struct DialScene: View {
    
    @EnvironmentObject private var hub: FlowHub
    @EnvironmentObject private var appLanguage: AppLanguageManager
    @State private var timeoutTask: Task<Void, Never>?
    
    private var l10n: L10n { L10n(bundle: appLanguage.currentBundle) }
    
    var body: some View {
        ZStack {
            SceneBackground()
            VStack(spacing: 0) {
                Spacer()
                OrbitDialView()
                VStack(spacing: 6) {
                    Text(l10n.dialTitle)
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(AppTheme.textOnDark)
                    Text(l10n.dialSubtitle)
                        .font(.system(size: 14, weight: .regular))
                        .foregroundColor(AppTheme.textOnDarkSecondary)
                }
                .padding(.top, 24)
                Spacer()
            }
            .padding(.horizontal, AppTheme.pageHorizontal)
        }
        .navigationBarBackButtonHidden(true) // 禁止手动返回，只允许流程自然结束或超时关闭
        .onAppear {
            // 页面出现即开始 40 秒计时，到点后仅隐藏本页，不改主流程状态
            timeoutTask = Task { [weak hub] in
                try? await Task.sleep(nanoseconds: 40 * 1_000_000_000)
                await MainActor.run {
                    guard let hub, hub.stage == .dialing else { return }
                    hub.setDialVisible(false)
                }
            }
        }
        .onDisappear {
            timeoutTask?.cancel()
            timeoutTask = nil
        }
    }
}

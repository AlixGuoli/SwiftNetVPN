import SwiftUI

/// 连接过程页面：旋转环动画（Logo 轨道感）在此页
struct DialScene: View {
    
    @EnvironmentObject private var hub: FlowHub
    @EnvironmentObject private var appLanguage: AppLanguageManager
    
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
    }
}

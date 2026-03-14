import SwiftUI

/// 启动画面：品牌 logo + 名称 + 标语 + 进度条 + 版本，结束后回调
struct SplashScene: View {
    
    @EnvironmentObject private var appLanguage: AppLanguageManager
    let onFinished: () -> Void
    
    private let duration: TimeInterval = 1.2
    
    @State private var progress: CGFloat = 0
    @State private var hasFired = false
    
    private var l10n: L10n { L10n(bundle: appLanguage.currentBundle) }
    
    var body: some View {
        ZStack {
            SceneBackground()
            VStack(spacing: 0) {
                Spacer(minLength: 60)
                VStack(spacing: 20) {
                    Image("logo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 88, height: 88)
                        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                        .shadow(color: AppTheme.titleBlue.opacity(0.25), radius: 20, x: 0, y: 8)
                    Text(Bundle.main.appDisplayName)
                        .font(.system(size: 34, weight: .bold))
                        .tracking(-0.5)
                        .foregroundColor(AppTheme.textOnDark)
                    Text(l10n.splashTagline)
                        .font(.system(size: 15))
                        .foregroundColor(AppTheme.textOnDarkSecondary)
                }
                Spacer(minLength: 48)
                VStack(spacing: 24) {
                    GeometryReader { geo in
                        ZStack(alignment: .leading) {
                            Capsule()
                                .fill(AppTheme.surfaceOnDark)
                                .frame(height: 5)
                            Capsule()
                                .fill(
                                    LinearGradient(
                                        colors: [AppTheme.titleBlue, AppTheme.titleBlue.opacity(0.8)],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .frame(width: max(0, geo.size.width * progress), height: 5)
                        }
                    }
                    .frame(height: 5)
                    .padding(.horizontal, 56)
                    Text(l10n.splashVersion(Bundle.main.appVersion))
                        .font(.system(size: 12))
                        .foregroundColor(AppTheme.textOnDarkSecondary.opacity(0.8))
                }
                .padding(.bottom, 50)
            }
        }
        .onAppear {
            guard !hasFired else { return }
            hasFired = true
            withAnimation(.easeInOut(duration: duration)) {
                progress = 1
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                onFinished()
            }
        }
    }
}

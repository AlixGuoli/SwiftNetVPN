import SwiftUI

/// 启动画面：简单展示品牌 + 进度条，结束后通过回调决定后续路由
struct SplashScene: View {
    
    @EnvironmentObject private var appLanguage: AppLanguageManager
    let onFinished: () -> Void
    
    private let duration: TimeInterval = 1.0
    
    @State private var progress: CGFloat = 0
    @State private var hasFired = false
    
    private var l10n: L10n { L10n(bundle: appLanguage.currentBundle) }
    
    var body: some View {
        ZStack {
            LinearGradient(colors: [.blue, .purple],
                           startPoint: .topLeading,
                           endPoint: .bottomTrailing)
                .ignoresSafeArea()
            
            VStack(spacing: 24) {
                Text(l10n.splashAppName)
                    .font(.system(size: 36, weight: .bold))
                    .foregroundColor(.white)
                Text(l10n.splashTagline)
                    .font(.footnote)
                    .foregroundColor(.white.opacity(0.8))
                
                // 粗略进度条
                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        Capsule()
                            .fill(.white.opacity(0.25))
                            .frame(height: 4)
                        Capsule()
                            .fill(.white)
                            .frame(width: geo.size.width * progress, height: 4)
                    }
                }
                .frame(height: 4)
                .padding(.horizontal, 48)
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


import SwiftUI

/// 首次进入主流程前的三屏引导（连接 / 选线 / 权限），样式与主 App 一致
struct OnboardingScene: View {
    
    @EnvironmentObject private var appLanguage: AppLanguageManager
    let onFinish: () -> Void
    
    @State private var page = 0
    
    private var l10n: L10n { L10n(bundle: appLanguage.currentBundle) }
    private let lastPageIndex = 2
    
    var body: some View {
        ZStack {
            SceneBackground()
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                HStack {
                    Spacer()
                    Button {
                        finish()
                    } label: {
                        Text(l10n.onboardSkip)
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(AppTheme.textOnDarkSecondary)
                            .padding(.vertical, 8)
                            .padding(.horizontal, 12)
                    }
                    .buttonStyle(.plain)
                }
                .padding(.horizontal, AppTheme.pageHorizontal)
                .padding(.top, AppTheme.pageTopSafe)
                
                TabView(selection: $page) {
                    onboardPage(
                        icon: "link.circle.fill",
                        title: l10n.onboardP1Title,
                        body: l10n.onboardP1Body
                    )
                    .tag(0)
                    
                    onboardPage(
                        icon: "globe.europe.africa.fill",
                        title: l10n.onboardP2Title,
                        body: l10n.onboardP2Body
                    )
                    .tag(1)
                    
                    onboardPage(
                        icon: "lock.shield.fill",
                        title: l10n.onboardP3Title,
                        body: l10n.onboardP3Body
                    )
                    .tag(2)
                }
                .tabViewStyle(.page(indexDisplayMode: .always))
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding(.top, 8)
            }
            .safeAreaInset(edge: .bottom, spacing: 0) {
                primaryButton
                    .padding(.horizontal, AppTheme.pageHorizontal)
                    .padding(.top, 12)
                    .padding(.bottom, 12)
            }
        }
    }
    
    private var primaryButton: some View {
        Button {
            if page >= lastPageIndex {
                finish()
            } else {
                withAnimation(.easeInOut(duration: 0.25)) {
                    page = min(page + 1, lastPageIndex)
                }
            }
        } label: {
            Text(page >= lastPageIndex ? l10n.onboardStart : l10n.onboardNext)
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(AppTheme.cosmicCanvasDeep)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .fill(
                            LinearGradient(
                                colors: [AppTheme.titleBlue, AppTheme.titleBlue.opacity(0.85)],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                )
        }
        .buttonStyle(.plain)
    }
    
    private func onboardPage(icon: String, title: String, body: String) -> some View {
        VStack(spacing: 24) {
            Spacer(minLength: 12)
            ZStack {
                Circle()
                    .fill(AppTheme.surfaceOnDark)
                    .frame(width: 120, height: 120)
                    .overlay(
                        Circle()
                            .stroke(AppTheme.surfaceOnDarkBorder, lineWidth: 1)
                    )
                Image(systemName: icon)
                    .font(.system(size: 44))
                    .foregroundStyle(AppTheme.titleBlue)
                    .symbolRenderingMode(.hierarchical)
            }
            VStack(spacing: 14) {
                Text(title)
                    .font(.system(size: 22, weight: .bold))
                    .foregroundColor(AppTheme.textOnDark)
                    .multilineTextAlignment(.center)
                Text(body)
                    .font(.system(size: 15))
                    .foregroundColor(AppTheme.textOnDarkSecondary)
                    .multilineTextAlignment(.center)
                    .lineSpacing(5)
                    .padding(.horizontal, 8)
            }
            Spacer(minLength: 24)
        }
        .padding(.horizontal, AppTheme.pageHorizontal)
    }
    
    private func finish() {
        onFinish()
    }
}

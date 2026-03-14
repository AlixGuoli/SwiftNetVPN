import SwiftUI

/// 小工具列表页：两列卡片布局
struct ToolsScene: View {
    
    @EnvironmentObject private var appLanguage: AppLanguageManager
    @Environment(\.navigateToRoute) private var navigateToRoute
    
    private var l10n: L10n { L10n(bundle: appLanguage.currentBundle) }
    
    private let tools: [(icon: String, route: Route, titleKey: KeyPath<L10n, String>)] = [
        ("network", .toolIP, \.toolIPTitle),
        ("speedometer", .toolPing, \.toolPingTitle),
        ("lock.shield", .toolDNS, \.toolDNSTitle),
        ("chart.line.uptrend.xyaxis", .toolSpeed, \.toolSpeedTitle),
        ("dice", .toolRandom, \.toolRandomTitle),
        ("key", .toolPassword, \.toolPasswordTitle)
    ]
    
    var body: some View {
        let columns = [
            GridItem(.flexible(), spacing: 16),
            GridItem(.flexible(), spacing: 16)
        ]
        
        return ZStack {
            SceneBackground()
            ScrollView {
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(Array(tools.enumerated()), id: \.offset) { _, t in
                        Button {
                            navigateToRoute(t.route)
                        } label: {
                            VStack(spacing: 10) {
                                Image(systemName: t.icon)
                                    .font(.system(size: 24))
                                    .foregroundStyle(AppTheme.titleBlue)
                                    .frame(width: 40, height: 40)
                                    .background(
                                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                                            .fill(AppTheme.surfaceOnDark)
                                    )
                                Text(l10n[keyPath: t.titleKey])
                                    .font(.system(size: 15, weight: .medium))
                                    .foregroundColor(AppTheme.textOnDark)
                                    .multilineTextAlignment(.center)
                                    .lineLimit(2)
                            }
                            .frame(maxWidth: .infinity, minHeight: 110)
                            .padding(12)
                            .background(
                                RoundedRectangle(cornerRadius: AppTheme.surfaceCorner, style: .continuous)
                                    .fill(AppTheme.surfaceOnDark)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: AppTheme.surfaceCorner, style: .continuous)
                                            .stroke(AppTheme.surfaceOnDarkBorder, lineWidth: 1)
                                    )
                            )
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal, AppTheme.pageHorizontal)
                .padding(.top, 20)
                .padding(.bottom, 24)
            }
        }
        .navigationTitle(l10n.toolsTitle)
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(.hidden, for: .navigationBar)
    }
}

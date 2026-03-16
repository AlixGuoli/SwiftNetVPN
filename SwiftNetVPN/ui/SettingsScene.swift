import SwiftUI

/// 设置页：分组标题 + 独立圆角卡片，不用 List
struct SettingsScene: View {
    
    @EnvironmentObject private var appLanguage: AppLanguageManager
    @Environment(\.navigateToRoute) private var navigateToRoute
    
    private var l10n: L10n { L10n(bundle: appLanguage.currentBundle) }
    
    var body: some View {
        ZStack {
            SceneBackground()
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    sectionBlock(title: l10n.settingsSectionGeneral) {
                        itemRow(icon: "globe", text: l10n.settingsLanguage) { navigateToRoute(.language) }
                    }
                    sectionBlock(title: l10n.settingsSectionInfo) {
                        itemRow(icon: "info.circle", text: l10n.settingsAbout) { navigateToRoute(.about) }
                        itemRow(icon: "hand.raised", text: l10n.settingsPrivacy) { navigateToRoute(.privacy) }
                        itemRow(icon: "doc.text", text: l10n.settingsTerms) { navigateToRoute(.terms) }
                        itemRow(icon: "envelope", text: l10n.settingsContact) { navigateToRoute(.contact) }
                    }
                    sectionBlock(title: l10n.settingsSectionTools) {
                        itemRow(icon: "wrench.and.screwdriver", text: l10n.settingsToolsEntry, showChevron: true) {
                            navigateToRoute(.tools)
                        }
                    }
                }
                .padding(.horizontal, AppTheme.pageHorizontal)
                .padding(.vertical, 16)
            }
        }
        .navigationTitle(l10n.settingsTitle)
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(.hidden, for: .navigationBar)
    }
    
    private func sectionBlock<Content: View>(title: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.system(size: 13, weight: .medium))
                .foregroundColor(AppTheme.textOnDarkSecondary)
                .padding(.leading, 4)
            VStack(spacing: 12) {
                content()
            }
        }
    }
    
    private func itemRow(icon: String, text: String, muted: Bool = false, showChevron: Bool = false, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.system(size: 18))
                    .foregroundStyle(muted ? AppTheme.textOnDarkSecondary : AppTheme.titleBlue)
                    .frame(width: 28, alignment: .center)
                Text(text)
                    .foregroundColor(muted ? AppTheme.textOnDarkSecondary : AppTheme.textOnDark)
                    .font(.system(size: 16, weight: .medium))
                Spacer(minLength: 8)
                if showChevron {
                    Image(systemName: "chevron.right")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(AppTheme.textOnDarkSecondary)
                }
            }
            .padding(.horizontal, 18)
            .padding(.vertical, 18)
            .frame(maxWidth: .infinity, minHeight: 64, alignment: .leading)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .disabled(muted)
        .background(
            RoundedRectangle(cornerRadius: AppTheme.surfaceCorner, style: .continuous)
                .fill(AppTheme.surfaceOnDark)
        )
    }
}

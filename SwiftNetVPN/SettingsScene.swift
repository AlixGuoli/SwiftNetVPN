import SwiftUI

/// 设置页（占位，后续扩展）
struct SettingsScene: View {
    
    @EnvironmentObject private var appLanguage: AppLanguageManager
    
    private var l10n: L10n { L10n(bundle: appLanguage.currentBundle) }
    
    var body: some View {
        List {
            Section {
                NavigationLink {
                    LanguageScene()
                } label: {
                    Text(l10n.settingsLanguage)
                }
                Text(l10n.settingsGeneral)
            } header: {
                Text(l10n.settingsSectionGeneral)
            }
        }
        .navigationTitle(l10n.settingsTitle)
        .navigationBarTitleDisplayMode(.inline)
    }
}

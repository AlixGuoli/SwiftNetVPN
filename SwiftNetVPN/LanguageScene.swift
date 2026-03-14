import SwiftUI

/// 语言页：App 内切换显示语言（en / 简体中文）
struct LanguageScene: View {
    
    @EnvironmentObject private var appLanguage: AppLanguageManager
    @Environment(\.dismiss) private var dismiss
    
    private var l10n: L10n { L10n(bundle: appLanguage.currentBundle) }
    
    private let options: [(code: String, labelKey: String)] = [
        ("en", "language_english"),
        ("zh-Hans", "language_chinese")
    ]
    
    var body: some View {
        List {
            ForEach(options, id: \.code) { item in
                let label = L10n(bundle: appLanguage.currentBundle).string(item.labelKey)
                Button {
                    appLanguage.setLanguage(item.code)
                    dismiss()
                } label: {
                    HStack {
                        Text(label)
                        Spacer()
                        if appLanguage.currentLanguageCode == item.code {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.accentColor)
                        }
                    }
                }
            }
        }
        .navigationTitle(l10n.languageTitle)
        .navigationBarTitleDisplayMode(.inline)
    }
}

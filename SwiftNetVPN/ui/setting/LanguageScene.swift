import SwiftUI

/// 语言页：自定义 item 行，不用 List
struct LanguageScene: View {
    
    @EnvironmentObject private var appLanguage: AppLanguageManager
    @Environment(\.dismiss) private var dismiss
    
    private var l10n: L10n { L10n(bundle: appLanguage.currentBundle) }
    
    /// 语言选项：英文优先，其次俄语，再是西/德/法
    private let options: [(code: String, labelKey: String)] = [
        ("en", "language_english"),
        ("ru", "language_russian"),
        ("es", "language_spanish"),
        ("de", "language_german"),
        ("fr", "language_french")
    ]
    
    var body: some View {
        ZStack {
            SceneBackground()
            ScrollView {
                VStack(spacing: 12) {
                    ForEach(options, id: \.code) { item in
                        let label = L10n(bundle: appLanguage.currentBundle).string(item.labelKey)
                        Button {
                            appLanguage.setLanguage(item.code)
                            dismiss()
                        } label: {
                            HStack(spacing: 12) {
                                Text(label)
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(AppTheme.textOnDark)
                                Spacer(minLength: 8)
                                if appLanguage.currentLanguageCode == item.code {
                                    Image(systemName: "checkmark.circle.fill")
                                        .font(.system(size: 20))
                                        .foregroundStyle(AppTheme.ringGreen)
                                }
                            }
                            .padding(.horizontal, 18)
                            .padding(.vertical, 18)
                            .frame(maxWidth: .infinity, minHeight: 64, alignment: .leading)
                            .contentShape(Rectangle())
                        }
                        .buttonStyle(.plain)
                        .background(
                            RoundedRectangle(cornerRadius: AppTheme.surfaceCorner, style: .continuous)
                                .fill(AppTheme.surfaceOnDark)
                        )
                    }
                }
                .padding(.horizontal, AppTheme.pageHorizontal)
                .padding(.top, 16)
                .padding(.bottom, 32)
            }
        }
        .navigationTitle(l10n.languageTitle)
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(.hidden, for: .navigationBar)
    }
}

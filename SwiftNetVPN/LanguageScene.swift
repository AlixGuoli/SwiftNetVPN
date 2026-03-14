import SwiftUI

/// 语言页：自定义 item 行，不用 List
struct LanguageScene: View {
    
    @EnvironmentObject private var appLanguage: AppLanguageManager
    @Environment(\.dismiss) private var dismiss
    
    private var l10n: L10n { L10n(bundle: appLanguage.currentBundle) }
    
    private let options: [(code: String, labelKey: String)] = [
        ("en", "language_english"),
        ("zh-Hans", "language_chinese")
    ]
    
    var body: some View {
        ZStack {
            SceneBackground()
            ScrollView {
                VStack(spacing: 0) {
                    ForEach(Array(options.enumerated()), id: \.element.code) { idx, item in
                        if idx > 0 {
                            Rectangle().fill(AppTheme.surfaceOnDarkBorder).frame(height: 1).padding(.leading, 16)
                        }
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
                            .padding(.horizontal, 16)
                            .padding(.vertical, 14)
                            .contentShape(Rectangle())
                        }
                        .buttonStyle(.plain)
                    }
                }
                .background(
                    RoundedRectangle(cornerRadius: AppTheme.surfaceCorner, style: .continuous)
                        .fill(AppTheme.surfaceOnDark)
                        .overlay(
                            RoundedRectangle(cornerRadius: AppTheme.surfaceCorner, style: .continuous)
                                .stroke(AppTheme.surfaceOnDarkBorder, lineWidth: 1)
                        )
                )
                .padding(.horizontal, AppTheme.pageHorizontal)
                .padding(.top, 16)
            }
        }
        .navigationTitle(l10n.languageTitle)
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(.hidden, for: .navigationBar)
    }
}

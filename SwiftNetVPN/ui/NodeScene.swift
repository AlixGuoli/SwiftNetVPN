import SwiftUI

/// 节点选择页：自定义 item 行，不用 List
struct NodeScene: View {
    
    @EnvironmentObject private var hub: FlowHub
    @EnvironmentObject private var appLanguage: AppLanguageManager
    @Environment(\.dismiss) private var dismiss
    
    private var l10n: L10n { L10n(bundle: appLanguage.currentBundle) }
    
    var body: some View {
        ZStack {
            SceneBackground()
            ScrollView {
                VStack(spacing: 12) {
                    ForEach(hub.lines, id: \.id) { node in
                        Button {
                            hub.choose(line: node)
                            dismiss()
                        } label: {
                            HStack(spacing: 12) {
                                nodeIcon(country: node.country)
                                Text(node.id == -1 ? l10n.lineAuto : node.name)
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(AppTheme.textOnDark)
                                Spacer(minLength: 8)
                                if hub.currentLine.id == node.id {
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
        .navigationTitle(l10n.nodesTitle)
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(.hidden, for: .navigationBar)
    }
    
    @ViewBuilder
    private func nodeIcon(country: String) -> some View {
        if country == "AUTO" {
            Image(systemName: "globe")
                .font(.system(size: 18))
                .foregroundStyle(AppTheme.titleBlue)
                .frame(width: 28, alignment: .center)
        } else {
            Text(flagEmoji(for: country))
                .font(.system(size: 20))
                .frame(width: 28, alignment: .center)
        }
    }
    
    private func flagEmoji(for countryCode: String) -> String {
        let u = countryCode.uppercased()
        guard u.count == 2,
              let a = u.unicodeScalars.first?.value,
              let b = u.unicodeScalars.dropFirst().first?.value,
              a >= 65, a <= 90, b >= 65, b <= 90 else {
            return "🌐"
        }
        let base: UInt32 = 0x1F1E6 - 65
        return String(UnicodeScalar(base + a)!) + String(UnicodeScalar(base + b)!)
    }
}

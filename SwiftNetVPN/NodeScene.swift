import SwiftUI

/// 节点选择页：第一版假节点列表，第二版可接后台 categories/nodes
struct NodeScene: View {
    
    @EnvironmentObject private var hub: FlowHub
    @EnvironmentObject private var appLanguage: AppLanguageManager
    @Environment(\.dismiss) private var dismiss
    
    private var l10n: L10n { L10n(bundle: appLanguage.currentBundle) }
    
    var body: some View {
        List {
            ForEach(hub.lines) { node in
                Button {
                    hub.choose(line: node)
                    dismiss()
                } label: {
                    HStack(spacing: 12) {
                        nodeIcon(country: node.country)
                        Text(node.id == -1 ? l10n.lineAuto : node.name)
                            .foregroundColor(.primary)
                        Spacer()
                        if hub.currentLine.id == node.id {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.accentColor)
                        }
                    }
                }
            }
        }
        .navigationTitle(l10n.nodesTitle)
        .navigationBarTitleDisplayMode(.inline)
    }
    
    @ViewBuilder
    private func nodeIcon(country: String) -> some View {
        if country == "AUTO" {
            Image(systemName: "globe")
                .font(.title2)
                .foregroundColor(.secondary)
                .frame(width: 28, alignment: .center)
        } else {
            Text(flagEmoji(for: country))
                .font(.title2)
                .frame(width: 28, alignment: .center)
        }
    }
    
    /// 国家码转旗帜 emoji（如 DE -> 🇩🇪）
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

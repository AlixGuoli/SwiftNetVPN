import SwiftUI

/// 连接过程页面
struct DialScene: View {
    
    @EnvironmentObject private var hub: FlowHub
    @EnvironmentObject private var appLanguage: AppLanguageManager
    
    private var l10n: L10n { L10n(bundle: appLanguage.currentBundle) }
    
    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: .accentColor))
                .scaleEffect(1.4)
            Text(l10n.dialTitle)
                .font(.headline)
            Text(l10n.dialSubtitle)
                .font(.footnote)
                .foregroundColor(.secondary)
            Spacer()
        }
        .padding()
    }
}


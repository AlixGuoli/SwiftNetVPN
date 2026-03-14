import SwiftUI

/// 结果展示页面
struct OutcomeScene: View {
    
    @EnvironmentObject private var appLanguage: AppLanguageManager
    let result: OutcomeFlag
    let onDismiss: () -> Void
    
    private var l10n: L10n { L10n(bundle: appLanguage.currentBundle) }
    
    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            Image(systemName: iconName)
                .font(.system(size: 48, weight: .semibold))
                .foregroundColor(iconColor)
            Text(titleText)
                .font(.title2.weight(.semibold))
            Text(detailText)
                .font(.footnote)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
            Button(l10n.outcomeBack) {
                onDismiss()
            }
            .buttonStyle(.borderedProminent)
            Spacer()
        }
        .padding()
    }
    
    private var iconName: String {
        switch result {
        case .success: return "checkmark.circle.fill"
        case .dropped: return "xmark.circle.fill"
        case .failure: return "exclamationmark.triangle.fill"
        }
    }
    
    private var iconColor: Color {
        switch result {
        case .success: return .green
        case .dropped: return .gray
        case .failure: return .orange
        }
    }
    
    private var titleText: String {
        switch result {
        case .success: return l10n.outcomeTitleSuccess
        case .dropped: return l10n.outcomeTitleDropped
        case .failure: return l10n.outcomeTitleFailure
        }
    }
    
    private var detailText: String {
        switch result {
        case .success: return l10n.outcomeDetailSuccess
        case .dropped: return l10n.outcomeDetailDropped
        case .failure: return l10n.outcomeDetailFailure
        }
    }
}


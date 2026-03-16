import SwiftUI

/// 随机数：与 VPN 无关的实用小工具，min～max 生成整数
struct RandomNumberScene: View {
    
    @EnvironmentObject private var appLanguage: AppLanguageManager
    @State private var minVal: String = "1"
    @State private var maxVal: String = "100"
    @State private var result: Int?
    @FocusState private var focusMin: Bool
    @FocusState private var focusMax: Bool
    
    private var l10n: L10n { L10n(bundle: appLanguage.currentBundle) }
    
    var body: some View {
        ZStack {
            SceneBackground()
            ScrollView {
                VStack(spacing: 24) {
                    SubpageStyle.card {
                        VStack(alignment: .leading, spacing: 16) {
                            Text(l10n.toolRandomTitle)
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundColor(AppTheme.textOnDark)
                            Text(l10n.toolRandomDesc)
                                .font(.system(size: 14))
                                .foregroundColor(AppTheme.textOnDarkSecondary)
                                .lineSpacing(4)
                            
                            HStack(spacing: 16) {
                                VStack(alignment: .leading, spacing: 6) {
                                    Text(l10n.toolRandomMin)
                                        .font(.system(size: 12))
                                        .foregroundColor(AppTheme.textOnDarkSecondary)
                                    TextField("1", text: $minVal)
                                        .keyboardType(.numberPad)
                                        .font(.system(size: 17, design: .monospaced))
                                        .foregroundColor(AppTheme.textOnDark)
                                        .padding(12)
                                        .background(RoundedRectangle(cornerRadius: 10, style: .continuous).fill(AppTheme.cosmicCanvasDeep))
                                        .focused($focusMin)
                                }
                                VStack(alignment: .leading, spacing: 6) {
                                    Text(l10n.toolRandomMax)
                                        .font(.system(size: 12))
                                        .foregroundColor(AppTheme.textOnDarkSecondary)
                                    TextField("100", text: $maxVal)
                                        .keyboardType(.numberPad)
                                        .font(.system(size: 17, design: .monospaced))
                                        .foregroundColor(AppTheme.textOnDark)
                                        .padding(12)
                                        .background(RoundedRectangle(cornerRadius: 10, style: .continuous).fill(AppTheme.cosmicCanvasDeep))
                                        .focused($focusMax)
                                }
                            }
                            
                            Button {
                                generate()
                            } label: {
                                Text(l10n.toolRandomGenerate)
                                    .font(.system(size: 15, weight: .semibold))
                                    .foregroundColor(AppTheme.cosmicCanvasDeep)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 14)
                                    .background(RoundedRectangle(cornerRadius: 12, style: .continuous).fill(AppTheme.textOnDark))
                            }
                            
                            if let result = result {
                                HStack {
                                    Text(l10n.toolRandomResult)
                                        .font(.system(size: 14))
                                        .foregroundColor(AppTheme.textOnDarkSecondary)
                                    Spacer()
                                    Text("\(result)")
                                        .font(.system(size: 28, weight: .bold, design: .monospaced))
                                        .foregroundColor(AppTheme.titleBlue)
                                }
                                .padding(.top, 8)
                            }
                        }
                    }
                }
                .padding(.horizontal, AppTheme.pageHorizontal)
                .padding(.top, 20)
                .padding(.bottom, 32)
            }
        }
        .navigationTitle(l10n.toolRandomTitle)
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(.hidden, for: .navigationBar)
    }
    
    private func generate() {
        let a = Int(minVal) ?? 0
        let b = Int(maxVal) ?? 100
        let low = min(a, b)
        let high = max(a, b)
        result = Int.random(in: low...high)
    }
}

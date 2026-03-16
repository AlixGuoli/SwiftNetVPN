import SwiftUI

/// 随机密码：生成可复制的随机密码，与账号/密钥等场景相关
struct PasswordGenScene: View {
    
    @EnvironmentObject private var appLanguage: AppLanguageManager
    @State private var length: Double = 16
    @State private var includeSymbols = true
    @State private var password: String = ""
    @State private var copied = false
    
    private var l10n: L10n { L10n(bundle: appLanguage.currentBundle) }
    
    private let chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    private let symbols = "!@#$%&*()-_=+[]{};:,.<>?"
    
    var body: some View {
        ZStack {
            SceneBackground()
            ScrollView {
                VStack(spacing: 24) {
                    SubpageStyle.card {
                        VStack(alignment: .leading, spacing: 16) {
                            Text(l10n.toolPasswordTitle)
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundColor(AppTheme.textOnDark)
                            Text(l10n.toolPasswordDesc)
                                .font(.system(size: 14))
                                .foregroundColor(AppTheme.textOnDarkSecondary)
                                .lineSpacing(4)
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text(l10n.toolPasswordLength)
                                    .font(.system(size: 12))
                                    .foregroundColor(AppTheme.textOnDarkSecondary)
                                HStack(spacing: 12) {
                                    Slider(value: $length, in: 8...32, step: 1)
                                        .tint(AppTheme.titleBlue)
                                    Text("\(Int(length))")
                                        .font(.system(size: 15, weight: .medium, design: .monospaced))
                                        .foregroundColor(AppTheme.textOnDark)
                                        .frame(width: 28, alignment: .trailing)
                                }
                            }
                            
                            Toggle(isOn: $includeSymbols) {
                                Text(l10n.toolPasswordSymbols)
                                    .font(.system(size: 15))
                                    .foregroundColor(AppTheme.textOnDark)
                            }
                            .tint(AppTheme.titleBlue)
                            
                            Button {
                                generate()
                            } label: {
                                Text(l10n.toolPasswordGenerate)
                                    .font(.system(size: 15, weight: .semibold))
                                    .foregroundColor(AppTheme.cosmicCanvasDeep)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 14)
                                    .background(RoundedRectangle(cornerRadius: 12, style: .continuous).fill(AppTheme.textOnDark))
                            }
                            
                            if !password.isEmpty {
                                VStack(spacing: 12) {
                                    Text(password)
                                        .font(.system(size: 15, design: .monospaced))
                                        .foregroundColor(AppTheme.titleBlue)
                                        .lineLimit(2)
                                        .minimumScaleFactor(0.8)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .padding(14)
                                        .background(RoundedRectangle(cornerRadius: 10, style: .continuous).fill(AppTheme.cosmicCanvasDeep))
                                    Button {
                                        UIPasteboard.general.string = password
                                        copied = true
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                            copied = false
                                        }
                                    } label: {
                                        Text(copied ? l10n.toolPasswordCopied : l10n.toolPasswordCopy)
                                            .font(.system(size: 15, weight: .semibold))
                                            .foregroundColor(AppTheme.cosmicCanvasDeep)
                                            .frame(maxWidth: .infinity)
                                            .padding(.vertical, 14)
                                            .background(RoundedRectangle(cornerRadius: 12, style: .continuous).fill(AppTheme.textOnDark))
                                    }
                                    .buttonStyle(.plain)
                                }
                                .padding(.top, 4)
                            }
                        }
                    }
                    
                    SubpageStyle.card {
                        VStack(alignment: .leading, spacing: 10) {
                            Text(l10n.toolTipsTitle)
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(AppTheme.textOnDark)
                            Text(l10n.toolPasswordTips)
                                .font(.system(size: 14))
                                .foregroundColor(AppTheme.textOnDarkSecondary)
                                .lineSpacing(5)
                        }
                    }
                }
                .padding(.horizontal, AppTheme.pageHorizontal)
                .padding(.top, 20)
                .padding(.bottom, 32)
            }
        }
        .navigationTitle(l10n.toolPasswordTitle)
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(.hidden, for: .navigationBar)
    }
    
    private func generate() {
        let len = Int(length)
        let set = includeSymbols ? (chars + symbols) : chars
        password = String((0..<len).map { _ in set.randomElement()! })
    }
}

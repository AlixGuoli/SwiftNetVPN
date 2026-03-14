import SwiftUI

/// 子页统一样式：内容卡片 + 外链按钮
enum SubpageStyle {
    
    /// 内容卡片容器
    static func card<Content: View>(@ViewBuilder content: () -> Content) -> some View {
        content()
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: AppTheme.surfaceCorner, style: .continuous)
                    .fill(AppTheme.surfaceOnDark)
                    .overlay(
                        RoundedRectangle(cornerRadius: AppTheme.surfaceCorner, style: .continuous)
                            .stroke(AppTheme.surfaceOnDarkBorder, lineWidth: 1)
                    )
            )
    }
    
    /// 外链按钮（打开 Safari）
    static func linkButton(title: String, url: URL) -> some View {
        Link(destination: url) {
            HStack(spacing: 8) {
                Text(title)
                    .font(.system(size: 15, weight: .semibold))
                Image(systemName: "arrow.up.right")
                    .font(.system(size: 12, weight: .semibold))
            }
            .foregroundColor(AppTheme.cosmicCanvasDeep)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .background(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(AppTheme.textOnDark)
            )
        }
    }
}

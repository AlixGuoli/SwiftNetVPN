import SwiftUI

/// Logo 延展的 UI 色板与尺寸（主按钮环+中心、背景、标题）
enum AppTheme {
    
    // MARK: - 宇宙画布（深底，和按钮中心的 void 同体系）
    static let cosmicCanvas = Color(red: 0.06, green: 0.08, blue: 0.18)
    static let cosmicCanvasTop = Color(red: 0.09, green: 0.11, blue: 0.24)
    static let cosmicCanvasDeep = Color(red: 0.03, green: 0.04, blue: 0.12)
    static let cosmicSpotlight = Color(red: 0.14, green: 0.18, blue: 0.35)
    
    // MARK: - 画布上的文字
    static let textOnDark = Color(red: 0.95, green: 0.96, blue: 1.0)
    static let textOnDarkSecondary = Color(red: 0.55, green: 0.6, blue: 0.75)
    
    // MARK: - 画布上的表面（卡片、列表）
    static let surfaceOnDark = Color.white.opacity(0.06)
    static let surfaceOnDarkBorder = Color.white.opacity(0.08)
    
    // MARK: - 强调色（图标、线条，与轨道呼应）
    static let titleBlue = Color(red: 0.45, green: 0.55, blue: 0.9)
    static let secondaryText = Color(red: 0.55, green: 0.6, blue: 0.75)
    
    // MARK: - 主按钮：未连接 / 失败（红橙）
    static let ringRedOrange = Color(red: 0.95, green: 0.35, blue: 0.18)
    static let ringRedOrangeLight = Color(red: 1.0, green: 0.5, blue: 0.3)
    static let orbRedOrange = Color(red: 0.9, green: 0.32, blue: 0.2)
    static let orbRedOrangeHighlight = Color(red: 1.0, green: 0.6, blue: 0.45)
    
    // MARK: - 主按钮：已连接（青绿）
    static let ringGreen = Color(red: 0.35, green: 0.88, blue: 0.4)
    static let ringGreenLight = Color(red: 0.5, green: 0.95, blue: 0.55)
    static let orbGreen = Color(red: 0.3, green: 0.82, blue: 0.38)
    static let orbGreenHighlight = Color(red: 0.55, green: 0.95, blue: 0.5)
    
    // MARK: - 连接页旋转环（白 + 浅蓝）
    static let dialRingWhite = Color.white
    static let dialRingShadow = Color.white.opacity(0.4)
    
    // MARK: - 主按钮尺寸
    static let mainButtonOuter: CGFloat = 200
    static let mainButtonRingWidth: CGFloat = 6  // 细一圈，和轨道同属一个整体
    static let mainButtonInner: CGFloat = 172
    
    // MARK: - 主按钮光晕（与轨道一致）
    static let glowRedOrange = Color(red: 1.0, green: 0.4, blue: 0.2).opacity(0.5)
    static let glowGreen = Color(red: 0.4, green: 0.9, blue: 0.45).opacity(0.5)
    static let accentOrbLight = Color.white.opacity(0.12)
    static let accentOrbMid = Color(red: 0.6, green: 0.8, blue: 1.0).opacity(0.15)
    
    // MARK: - 空心宇宙中心（深邃 + 立体）
    static let cosmicVoidCenter = Color(red: 0.01, green: 0.02, blue: 0.08)
    static let cosmicVoidDeep = Color(red: 0.04, green: 0.05, blue: 0.18)
    static let cosmicVoidMid = Color(red: 0.08, green: 0.1, blue: 0.28)
    static let cosmicVoidEdge = Color(red: 0.12, green: 0.15, blue: 0.38)
    static let cosmicRimLight = Color.white.opacity(0.08)
    static let cosmicRimHighlight = Color.white.opacity(0.2)  // 立体高光边
    static let cosmicInnerShadow = Color.black.opacity(0.5)   // 内部阴影加深
    
    // MARK: - 页面布局与表面（统一风格，减少系统感）
    static let pageHorizontal: CGFloat = 24
    static let pageTopSafe: CGFloat = 16
    static let titleSize: CGFloat = 32
    static let titleTracking: CGFloat = -0.5
    static let surfaceCorner: CGFloat = 16
    static let surfaceOpacity: Double = 0.72
    static let surfaceBorderOpacity: Double = 0.15
    static let listRowMinHeight: CGFloat = 52
}

// MARK: - App 名称与版本（全局从 Bundle 取，不在多语言里定义）
extension Bundle {
    var appDisplayName: String {
        (infoDictionary?["CFBundleDisplayName"] as? String)
            ?? (infoDictionary?["CFBundleName"] as? String)
            ?? "SwiftNet"
    }
    var appVersion: String {
        (infoDictionary?["CFBundleShortVersionString"] as? String) ?? "1.0"
    }
}

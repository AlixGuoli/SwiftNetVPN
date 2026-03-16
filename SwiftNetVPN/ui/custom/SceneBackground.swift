import SwiftUI

/// 宇宙画布：深色底 + 按钮区光晕 + 极淡轨道弧，与主按钮同一世界
struct SceneBackground: View {
    var body: some View {
        GeometryReader { geo in
            let w = geo.size.width
            let h = geo.size.height
            ZStack {
                // 深色宇宙底（与按钮中心 void 同色系）
                LinearGradient(
                    colors: [
                        AppTheme.cosmicCanvasTop,
                        AppTheme.cosmicCanvas,
                        AppTheme.cosmicCanvasDeep
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
                // 按钮位置的一圈柔和光晕（像轨道在发光）
                RadialGradient(
                    colors: [
                        AppTheme.cosmicSpotlight.opacity(0.9),
                        AppTheme.cosmicSpotlight.opacity(0.3),
                        .clear
                    ],
                    center: UnitPoint(x: 0.5, y: 0.38),
                    startRadius: 40,
                    endRadius: 180
                )
                // 一条极淡的轨道弧（和主按钮轨道呼应）
                Circle()
                    .trim(from: 0.2, to: 0.65)
                    .stroke(
                        LinearGradient(
                            colors: [
                                AppTheme.titleBlue.opacity(0.08),
                                AppTheme.titleBlue.opacity(0.02),
                                .clear
                            ],
                            startPoint: .leading,
                            endPoint: .trailing
                        ),
                        style: StrokeStyle(lineWidth: 80, lineCap: .round)
                    )
                    .frame(width: w * 1.2, height: w * 1.2)
                    .offset(x: w * 0.1, y: h * 0.35)
                    .blur(radius: 20)
            }
        }
        .ignoresSafeArea()
    }
}

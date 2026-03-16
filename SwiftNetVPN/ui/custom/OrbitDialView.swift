import SwiftUI

/// 连接中页的环球动画：多轨道环 + 轨道上节点绕行 + 中心球
struct OrbitDialView: View {
    
    var body: some View {
        TimelineView(.animation(minimumInterval: 0.016)) { context in
            let t = context.date.timeIntervalSinceReferenceDate
            let angle1 = (t * 0.22).truncatingRemainder(dividingBy: 1.0) * 360
            let angle2 = (t * -0.18).truncatingRemainder(dividingBy: 1.0) * 360
            let angle3 = (t * 0.28).truncatingRemainder(dividingBy: 1.0) * 360
            
            ZStack {
                // 最外轨道（顺时针）+ 两个节点
                orbitRing(
                    size: 200,
                    trimFrom: 0.12,
                    trimTo: 0.72,
                    strokeGradient: LinearGradient(
                        colors: [AppTheme.dialRingShadow, AppTheme.dialRingWhite, AppTheme.dialRingShadow],
                        startPoint: .leading,
                        endPoint: .trailing
                    ),
                    lineWidth: 10,
                    rotation: angle1
                )
                orbitNode(radius: 100, angle: angle1, size: 16)
                orbitNode(radius: 100, angle: angle1 + 180, size: 12)
                
                // 中层轨道（逆时针）+ 单节点
                orbitRing(
                    size: 160,
                    trimFrom: 0.2,
                    trimTo: 0.8,
                    strokeGradient: LinearGradient(
                        colors: [AppTheme.dialRingWhite.opacity(0.5), AppTheme.dialRingWhite.opacity(0.9), AppTheme.dialRingWhite.opacity(0.4)],
                        startPoint: .leading,
                        endPoint: .trailing
                    ),
                    lineWidth: 6,
                    rotation: angle2
                )
                orbitNode(radius: 80, angle: angle2, size: 10)
                
                // 内层轨道（顺时针，更快）
                orbitRing(
                    size: 124,
                    trimFrom: 0.1,
                    trimTo: 0.6,
                    strokeGradient: LinearGradient(
                        colors: [Color.white.opacity(0.3), Color.white.opacity(0.7)],
                        startPoint: .leading,
                        endPoint: .trailing
                    ),
                    lineWidth: 4,
                    rotation: angle3
                )
                orbitNode(radius: 62, angle: angle3, size: 8)
                
                // 中心：空心宇宙（与主按钮风格一致，星球在环上绕行）
                cosmicCenterView(size: 44)
                    .shadow(color: .black.opacity(0.2), radius: 8)
                    .shadow(color: AppTheme.titleBlue.opacity(0.15), radius: 10)
            }
        }
    }
    
    private func orbitRing(
        size: CGFloat,
        trimFrom: CGFloat,
        trimTo: CGFloat,
        strokeGradient: LinearGradient,
        lineWidth: CGFloat,
        rotation: Double
    ) -> some View {
        Circle()
            .trim(from: trimFrom, to: trimTo)
            .stroke(strokeGradient, style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))
            .frame(width: size, height: size)
            .rotationEffect(.degrees(rotation))
    }
    
    private func orbitNode(radius: CGFloat, angle: Double, size: CGFloat) -> some View {
        let rad = angle * .pi / 180
        return Circle()
            .fill(Color.white)
            .frame(width: size, height: size)
            .overlay(Circle().stroke(AppTheme.dialRingWhite.opacity(0.8), lineWidth: 1.5))
            .shadow(color: .black.opacity(0.15), radius: 3)
            .offset(x: radius * cos(rad), y: -radius * sin(rad))
    }
    
    /// 空心宇宙中心（与主按钮同款立体感，尺寸较小）
    private func cosmicCenterView(size: CGFloat) -> some View {
        let r = size / 2
        return ZStack {
            Circle()
                .fill(
                    RadialGradient(
                        colors: [
                            AppTheme.cosmicVoidCenter,
                            AppTheme.cosmicVoidDeep,
                            AppTheme.cosmicVoidMid,
                            AppTheme.cosmicVoidEdge
                        ],
                        center: .center,
                        startRadius: 0,
                        endRadius: r
                    )
                )
                .frame(width: size, height: size)
            Circle()
                .fill(
                    RadialGradient(
                        colors: [.clear, AppTheme.cosmicInnerShadow.opacity(0.35)],
                        center: UnitPoint(x: 0.65, y: 0.65),
                        startRadius: 0,
                        endRadius: r * 1.4
                    )
                )
                .frame(width: size, height: size)
            Circle()
                .fill(
                    RadialGradient(
                        colors: [Color.white.opacity(0.2), Color.white.opacity(0.05), .clear],
                        center: UnitPoint(x: 0.28, y: 0.28),
                        startRadius: 0,
                        endRadius: r * 0.9
                    )
                )
                .frame(width: size, height: size)
            Circle()
                .stroke(
                    AngularGradient(
                        colors: [
                            AppTheme.cosmicRimLight,
                            AppTheme.cosmicRimLight,
                            AppTheme.cosmicRimLight,
                            AppTheme.cosmicRimHighlight,
                            AppTheme.cosmicRimHighlight,
                            AppTheme.cosmicRimLight
                        ],
                        center: .center
                    ),
                    lineWidth: 1.5
                )
                .frame(width: size, height: size)
            TimelineView(.animation(minimumInterval: 0.08)) { context in
                let t = context.date.timeIntervalSinceReferenceDate
                let angle = (t * 0.06).truncatingRemainder(dividingBy: 1.0) * 2 * Double.pi
                ZStack {
                    Circle().fill(Color.white.opacity(0.8)).frame(width: 1.5, height: 1.5).offset(x: r * 0.25 * CGFloat(cos(angle)), y: -r * 0.25 * CGFloat(sin(angle)))
                    Circle().fill(Color.white.opacity(0.6)).frame(width: 1, height: 1).offset(x: r * 0.35 * CGFloat(cos(-angle * 0.8)), y: -r * 0.35 * CGFloat(sin(-angle * 0.8)))
                }
            }
        }
        .frame(width: size, height: size)
    }
}

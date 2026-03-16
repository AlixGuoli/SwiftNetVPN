import SwiftUI

/// 环球效果主按钮：轨道环旋转 + 轨道上的节点，中心为状态球
struct OrbitConnectButton: View {
    
    let stage: StageMark
    let title: String
    /// 可选：放在主文案下方，如「未连接」「已连接」
    var subtitle: String? = nil
    let ringGradient: AngularGradient
    let innerOrbGradient: LinearGradient
    let glowGradient: LinearGradient
    let glowColor: Color
    let scale: CGFloat
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            ZStack {
                // 最外光晕
                Circle()
                    .fill(glowGradient)
                    .frame(width: AppTheme.mainButtonOuter + 48, height: AppTheme.mainButtonOuter + 48)
                    .blur(radius: 30)
                
                // 主状态环：细线 + 与轨道同色系（统一成一体）
                Circle()
                    .stroke(
                        AngularGradient(
                            colors: [
                                glowColor.opacity(0.5),
                                glowColor.opacity(0.28),
                                glowColor.opacity(0.5)
                            ],
                            center: .center
                        ),
                        lineWidth: AppTheme.mainButtonRingWidth
                    )
                    .frame(width: AppTheme.mainButtonOuter, height: AppTheme.mainButtonOuter)
                
                // 内圈细环（同色系弱化，不抢戏）
                Circle()
                    .stroke(
                        LinearGradient(
                            colors: [
                                glowColor.opacity(0.22),
                                glowColor.opacity(0.08)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 1.5
                    )
                    .frame(width: AppTheme.mainButtonInner + 10, height: AppTheme.mainButtonInner + 10)
                
                // 中心：空心宇宙（深邃径向渐变 + 内缘光 + 内部星点）
                cosmicCenterView(size: AppTheme.mainButtonInner)
                    .shadow(color: .black.opacity(0.35), radius: 18, x: 0, y: 8)
                    .shadow(color: glowColor.opacity(0.25), radius: 14, x: 0, y: 0)
                
                // 环球层：旋转轨道 + 轨道上的节点（画在最上层，不被外圈挡）
                TimelineView(.animation(minimumInterval: 0.016)) { context in
                    let t = context.date.timeIntervalSinceReferenceDate
                    let angle = t.truncatingRemainder(dividingBy: 4.0) / 4.0 * 360
                    
                    ZStack {
                        // 轨道弧 1（与主环同色系，整体一致）
                        Circle()
                            .trim(from: 0.15, to: 0.75)
                            .stroke(
                                LinearGradient(
                                    colors: [
                                        glowColor.opacity(0.48),
                                        glowColor.opacity(0.22),
                                        glowColor.opacity(0.06)
                                    ],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                ),
                                style: StrokeStyle(lineWidth: 5, lineCap: .round)
                            )
                            .frame(width: AppTheme.mainButtonOuter + 20, height: AppTheme.mainButtonOuter + 20)
                            .rotationEffect(.degrees(angle))
                        
                        // 轨道上的节点（沿轨道运动）
                        Circle()
                            .fill(.white)
                            .frame(width: 12, height: 12)
                            .overlay(Circle().stroke(glowColor.opacity(0.5), lineWidth: 1.5))
                            .shadow(color: .black.opacity(0.15), radius: 2)
                            .offset(y: -(AppTheme.mainButtonOuter / 2 + 10))
                            .rotationEffect(.degrees(angle))
                        
                        // 第二层轨道（同色系、反向）
                        Circle()
                            .trim(from: 0.05, to: 0.55)
                            .stroke(
                                LinearGradient(
                                    colors: [
                                        glowColor.opacity(0.32),
                                        glowColor.opacity(0.1)
                                    ],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                ),
                                style: StrokeStyle(lineWidth: 3, lineCap: .round)
                            )
                            .frame(width: AppTheme.mainButtonOuter + 8, height: AppTheme.mainButtonOuter + 8)
                            .rotationEffect(.degrees(-angle * 0.7))
                    }
                }
                
                VStack(spacing: 4) {
                    Text(title)
                        .font(.system(size: 21, weight: .bold))
                        .foregroundColor(.white)
                        .shadow(color: .black.opacity(0.3), radius: 2, x: 0, y: 1)
                    if let sub = subtitle, !sub.isEmpty {
                        Text(sub)
                            .font(.system(size: 13, weight: .medium))
                            .foregroundColor(.white.opacity(0.9))
                    }
                }
            }
            .scaleEffect(scale)
        }
        .buttonStyle(.plain)
    }
    
    /// 空心宇宙中心：立体深邃（多层径向 + 内缘高光 + 内部阴影 + 星点）
    private func cosmicCenterView(size: CGFloat) -> some View {
        let r = size / 2
        return ZStack {
            // 基底：多层径向渐变（中心更深，层次更明显）
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
            // 内部阴影：右下角加深，像凹进去的球腔
            Circle()
                .fill(
                    RadialGradient(
                        colors: [
                            .clear,
                            AppTheme.cosmicInnerShadow.opacity(0.4)
                        ],
                        center: UnitPoint(x: 0.65, y: 0.65),
                        startRadius: 0,
                        endRadius: r * 1.4
                    )
                )
                .frame(width: size, height: size)
            // 高光点：左上角反光，增强球面感
            Circle()
                .fill(
                    RadialGradient(
                        colors: [
                            Color.white.opacity(0.18),
                            Color.white.opacity(0.06),
                            .clear
                        ],
                        center: UnitPoint(x: 0.28, y: 0.28),
                        startRadius: 0,
                        endRadius: r * 0.9
                    )
                )
                .frame(width: size, height: size)
            // 内缘：带角度的高光（左上亮、右下暗 = 立体边）
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
                    lineWidth: 2
                )
                .frame(width: size, height: size)
            // 内部星点（缓慢旋转）
            TimelineView(.animation(minimumInterval: 0.05)) { context in
                let t = context.date.timeIntervalSinceReferenceDate
                let angle = (t * 0.04).truncatingRemainder(dividingBy: 1.0) * 2 * Double.pi
                ZStack {
                    cosmicStar(at: (r * 0.15 * CGFloat(cos(angle)), -r * 0.15 * CGFloat(sin(angle))), size: 2.5)
                    cosmicStar(at: (r * 0.35 * CGFloat(cos(angle + 1.2)), -r * 0.35 * CGFloat(sin(angle + 1.2))), size: 2)
                    cosmicStar(at: (r * 0.22 * CGFloat(cos(angle + 2.5)), -r * 0.22 * CGFloat(sin(angle + 2.5))), size: 1.5)
                    cosmicStar(at: (r * 0.4 * CGFloat(cos(-angle * 0.7)), -r * 0.4 * CGFloat(sin(-angle * 0.7))), size: 2)
                    cosmicStar(at: (r * 0.28 * CGFloat(cos(angle + 4)), -r * 0.28 * CGFloat(sin(angle + 4))), size: 1.5)
                }
            }
        }
        .frame(width: size, height: size)
    }
    
    private func cosmicStar(at offset: (CGFloat, CGFloat), size: CGFloat) -> some View {
        Circle()
            .fill(Color.white.opacity(0.75))
            .frame(width: size, height: size)
            .offset(x: offset.0, y: offset.1)
    }
}

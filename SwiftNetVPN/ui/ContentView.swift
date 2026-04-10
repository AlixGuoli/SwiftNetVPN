//
//  ContentView.swift
//  SwiftNetVPN
//
//  Created by zying on 2026/3/11.
//

import SwiftUI

/// 根视图：首次启动为整页流程 Splash → 隐私 → 引导 → 主页；非叠加层，避免 ATT 关闭后与引导抢同一 ZStack
struct ContentView: View {
    
    @EnvironmentObject private var appLanguage: AppLanguageManager
    @StateObject private var hub = FlowHub.shared
    @State private var path = NavigationPath()
    @State private var dialPushed = false
    
    private enum RootScreen: Equatable {
        case splash
        case privacy
        case onboarding
        case main
    }
    
    @State private var rootScreen: RootScreen = .splash
    
    var body: some View {
        Group {
            switch rootScreen {
            case .splash:
                SplashScene {
                    goAfterSplash()
                }
                .ignoresSafeArea()
                
            case .privacy:
                PrivacyScene(
                    onAgree: {
                        UserDefaults.standard.set(true, forKey: "sn_privacy_accepted")
                        goAfterPrivacyAccepted()
                    },
                    onDecline: {
                        exit(0)
                    }
                )
                .ignoresSafeArea()
                
            case .onboarding:
                // 不要对整个引导页 ignoresSafeArea，否则布局会延到 Home 条下面，主按钮会视觉上贴底
                OnboardingScene {
                    UserDefaults.standard.set(true, forKey: "sn_onboarding_completed")
                    rootScreen = .main
                }
                
            case .main:
                NavigationStack(path: $path) {
                    MainScene()
                        .navigationDestination(for: Route.self) { route in
                            switch route {
                            case .dial:
                                DialScene()
                            case .outcome(let flag):
                                OutcomeScene(result: flag) {
                                    hub.clearOutcome()
                                    path = NavigationPath()
                                }
                            case .settings:
                                SettingsScene()
                            case .nodes:
                                NodeScene()
                            case .language:
                                LanguageScene()
                            case .tools:
                                ToolsScene()
                            case .about:
                                AboutScene()
                            case .privacy:
                                PrivacyPolicyScene()
                            case .terms:
                                TermsScene()
                            case .contact:
                                ContactScene()
                            case .toolIP:
                                IPCheckScene()
                            case .toolPing:
                                PingScene()
                            case .toolDNS:
                                DNSLeakScene()
                            case .toolSpeed:
                                SpeedTestScene()
                            case .toolRandom:
                                RandomNumberScene()
                            case .toolPassword:
                                PasswordGenScene()
                            }
                        }
                }
                .preferredColorScheme(.dark)
                .environment(\.navigateToRoute, { path.append($0) })
                .environmentObject(hub)
                .onChange(of: hub.isDialViewVisible) { visible in
                    if visible {
                        if !dialPushed {
                            path.append(Route.dial)
                            dialPushed = true
                        }
                    } else {
                        if dialPushed, !path.isEmpty {
                            path.removeLast()
                            dialPushed = false
                        }
                    }
                }
                .onChange(of: hub.outcome) { flag in
                    guard let flag else { return }
                    path.append(Route.outcome(flag))
                }
            }
        }
        .animation(.easeInOut(duration: 0.25), value: rootScreen)
    }
    
    /// 启动页结束：按持久化状态决定下一整页
    private func goAfterSplash() {
        let privacyOk = UserDefaults.standard.bool(forKey: "sn_privacy_accepted")
        let onboardingOk = UserDefaults.standard.bool(forKey: "sn_onboarding_completed")
        if !privacyOk {
            rootScreen = .privacy
        } else if !onboardingOk {
            rootScreen = .onboarding
        } else {
            rootScreen = .main
        }
    }
    
    /// 隐私同意（含 ATT 弹窗结束后的回调）：进入引导页或主页
    private func goAfterPrivacyAccepted() {
        let onboardingOk = UserDefaults.standard.bool(forKey: "sn_onboarding_completed")
        rootScreen = onboardingOk ? .main : .onboarding
    }
}

/// 路由枚举（主流程 + 设置子页 + 工具箱子页）
enum Route: Hashable {
    case dial
    case outcome(OutcomeFlag)
    case settings
    case nodes
    case language
    case tools
    case about
    case privacy
    case terms
    case contact
    case toolIP
    case toolPing
    case toolDNS
    case toolSpeed
    case toolRandom
    case toolPassword
}

// MARK: - 导航环境

private struct NavigateToRouteKey: EnvironmentKey {
    static let defaultValue: ((Route) -> Void)? = nil
}

extension EnvironmentValues {
    var navigateToRoute: (Route) -> Void {
        get { self[NavigateToRouteKey.self] ?? { _ in } }
        set { self[NavigateToRouteKey.self] = newValue }
    }
}


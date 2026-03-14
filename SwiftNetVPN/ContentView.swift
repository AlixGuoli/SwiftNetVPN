//
//  ContentView.swift
//  SwiftNetVPN
//
//  Created by zying on 2026/3/11.
//

import SwiftUI

/// 根视图：主流程用 NavigationStack，启动页和隐私页用 ZStack 覆盖，不参与导航
struct ContentView: View {
    
    @StateObject private var hub = FlowHub.shared
    @State private var path = NavigationPath()
    @State private var dialPushed = false
    
    @State private var showWelcome = true
    @State private var hasAcceptedPrivacy = UserDefaults.standard.bool(forKey: "sn_privacy_accepted")
    
    var body: some View {
        ZStack {
            // 主流程：从主页面开始的导航栈
            NavigationStack(path: $path) {
                MainScene()
                    .environment(\.navigateToRoute, { path.append($0) })
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
                        }
                    }
            }
            .environmentObject(hub)
            .onChange(of: hub.stage) { stage in
                switch stage {
                case .dialing:
                    if !dialPushed {
                        path.append(Route.dial)
                        dialPushed = true
                    }
                default:
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
            
            // 启动页：仅在首次进入时覆盖，无返回
            if showWelcome {
                SplashScene {
                    showWelcome = false
                }
                .ignoresSafeArea()
            }
            
            // 隐私页：启动页结束后且未同意时覆盖，无返回；不同意则退出 App
            if !showWelcome && !hasAcceptedPrivacy {
                PrivacyScene(
                    onAgree: {
                        UserDefaults.standard.set(true, forKey: "sn_privacy_accepted")
                        hasAcceptedPrivacy = true
                    },
                    onDecline: {
                        exit(0)
                    }
                )
                .ignoresSafeArea()
            }
        }
    }
}

/// 路由枚举（仅主流程内的页面，后续可扩展 settings / nodes / more 等）
enum Route: Hashable {
    case dial
    case outcome(OutcomeFlag)
    case settings
    case nodes
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



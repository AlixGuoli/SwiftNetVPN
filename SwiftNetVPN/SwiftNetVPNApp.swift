//
//  SwiftNetVPNApp.swift
//  SwiftNetVPN
//
//  Created by zying on 2026/3/11.
//

import SwiftUI

@main
struct SwiftNetVPNApp: App {
    @StateObject private var appLanguage = AppLanguageManager.shared
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appLanguage)
        }
    }
}

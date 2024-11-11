//
//  WidgetsWallApp.swift
//  WidgetsWall
//
//  Created by on 2024/10/17.
//

import SwiftUI

@main
struct WidgetsWallApp: App {
    var body: some Scene {
        WindowGroup {
            // JavaScriptCore
            WWJavaScriptCore()
            
            // ContentView()
            // 灵动岛-实时通知
            // TimeNotifityView()
        }
        // 添加新窗口场景
//        WindowGroup(id: "SecondWindow") {
//            ChargingAnimationView()
//        }
//        .windowStyle(.hiddenTitleBar)
//        .defaultSize(width: 300, height: 400)
    }
}

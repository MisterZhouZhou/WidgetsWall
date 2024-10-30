//
//  ChargingShortcut.swift
//  WidgetsWall
//
//  Created by on 2024/10/29.
//  充电快捷指令工具

import AppIntents
import SwiftUI

struct ChargingShortcut: AppIntent {
    static var title = LocalizedStringResource("充电动画")
    static var description = IntentDescription("充电时显示动画")

    // 意图执行时，是否自动将应用拉起到前台
    static var openAppWhenRun: Bool = true


    @MainActor
    func perform() async throws -> some IntentResult {
        // 打开充电动画效果
        WindowManager.shared.showWindow()
        
        return .result()
    }
}

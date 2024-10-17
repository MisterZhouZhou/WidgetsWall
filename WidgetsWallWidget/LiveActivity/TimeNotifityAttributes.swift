//
//  TimeNotifityAttributes.swift
//  WidgetsWall
//
//  Created by on 2024/10/17.
//
import ActivityKit

struct TimeNotifityAttributes: ActivityAttributes {
    // 动态数据,接收到推送时会更新的数据
    public struct ContentState: Codable, Hashable {
        var emoji: String
        var title: String = "实时通知"
        var progress: Float = 0
    }

    // 静态数据
    var name: String
}

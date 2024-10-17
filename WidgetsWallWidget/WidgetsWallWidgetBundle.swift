//
//  WidgetsWallWidgetBundle.swift
//  WidgetsWallWidget
//
//  Created by on 2024/10/17.
//

import WidgetKit
import SwiftUI

@main
struct WidgetsWallWidgetBundle: WidgetBundle {
    var body: some Widget {
        WidgetsWallWidget()
        
        // WidgetsWallWidgetLiveActivity()
        
        // 实时活动通知
        TimeNotifityLiveActivity()
        
        // 字体动画小组件
        TextWidget()
        
        // 时间状态小组件
        TodayWidget()
        
        // gif动画小组件
        GifAnimateWidget()
    }
}

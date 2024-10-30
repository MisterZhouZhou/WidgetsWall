//
//  DynamicFontWidget.swift
//  WidgetsWallWidgetExtension
//
//  Created by on 2024/10/17.
//  动态字体动画 小组件

import WidgetKit
import SwiftUI

struct DynamicFontWidgetEntryView : View {
    var entry: CommonProvider.Entry

    private let longDateFormat: DateFormatter = {
      let formatter = DateFormatter()
      formatter.dateFormat = "HH:mm:ss"
      return formatter
    }()

    private func tick() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            WidgetCenter.shared.reloadAllTimelines()
            tick()
        }
    }

    var body: some View {
        VStack() {
            Text(
               Calendar.current.startOfDay(for: Date()),
               style: .timer
            )
            .contentTransition(.identity) // iOS 17 新增了复杂的Timer过渡动画，想用的话可把这行注释掉
            .lineLimit(1)
            .multilineTextAlignment(.trailing) // 对齐方式必须是trailing
            .truncationMode(.head) // 截断方式必须是head
            .font(Font.custom("DynamicFont-Regular", size: 85))
            .offset(x: -90, y: 50)
        }
        .widgetBackground(Color.white)
    }
}

struct DynamicFontWidget: Widget {
    let kind: String = "DynamicFontWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: CommonProvider()) { entry in
            DynamicFontWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("字体图片动画小组件")
        .description("This is an example widget.")
        .supportedFamilies([.systemSmall])
    }
}

//#Preview(as: .systemSmall) {
//    DynamicFontWidget()
//} timeline: {
//    CommonEntry(date: .now)
//}

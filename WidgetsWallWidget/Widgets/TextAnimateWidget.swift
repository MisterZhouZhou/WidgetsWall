//
//  TextAnimateWidget.swift
//  WidgetsWallWidgetExtension
//
//  Created by on 2024/10/17.
//  倒计时/字体动画 小组件

import WidgetKit
import SwiftUI

struct TextWidgetEntryView : View {
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
            Text(entry.date, style: .time)
            Text(Calendar.current.startOfDay(for: Date()), style: .timer)
                .multilineTextAlignment(.center)
            Text(Calendar.current.startOfDay(for: Date()), style: .timer)
                .font(Font.custom("test-font-Regular", size: 30))
                .multilineTextAlignment(.center)
        }
        .widgetBackground(Color.white)
    }
}

struct TextWidget: Widget {
    let kind: String = "TextWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: CommonProvider()) { entry in
            TextWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("字体动画小组件")
        .description("This is an example widget.")
        .supportedFamilies([.systemSmall])
    }
}

//#Preview(as: .systemSmall) {
//    TextWidget()
//} timeline: {
//    CommonEntry(date: .now)
//}

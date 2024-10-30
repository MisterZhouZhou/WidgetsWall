//
//  File.swift
//  WidgetsWall
//
//  Created by on 2024/10/17.
//  时间状态 小组件

import SwiftUI
import WidgetKit

enum TodayTime {
   case morning, afternoon, night
    
    var text: String {
        switch self {
        case .morning:
            return "上午"
        case .afternoon:
            return "下午"
        case .night:
            return "晚上"
        }
    }
    
    var icon: String {
        switch self {
        case .morning:
            return "sunrise"
        case .afternoon:
            return "sunset"
        case .night:
            return "moon.stars"
        }
    }
}

struct TodayEntry: TimelineEntry {
    let date: Date
    // 表示上午、下午、晚上
    let time: TodayTime
}

// 指定当天时间
func getDate(hour: Int) -> Date {
    let calendar = Calendar.current
    var components = calendar.dateComponents([.year, .month, .day], from: Date())
    components.hour = hour
    components.minute = 0
    components.second = 0

    return calendar.date(from: components)!
}

struct TodayProvider: TimelineProvider {
    func placeholder(in context: Context) -> TodayEntry {
        TodayEntry(date: Date(), time: .morning)
    }

    func getSnapshot(in context: Context, completion: @escaping (TodayEntry) -> ()) {
        let entry = TodayEntry(date: Date(), time: .morning)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [TodayEntry] = []
        
        // 根据当前时间指定刷新时间线
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 0..<12:
            entries.append(TodayEntry(date: Date(), time: .morning))
            entries.append(TodayEntry(date: getDate(hour: 12), time: .afternoon))
            entries.append(TodayEntry(date: getDate(hour: 18), time: .night))
        case 12..<18:
            entries.append(TodayEntry(date: Date(), time: .afternoon))
            entries.append(TodayEntry(date: getDate(hour: 18), time: .night))
        default:
            entries.append(TodayEntry(date: Date(), time: .night))
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct TodayWidgetEntryView : View {
    var entry: TodayProvider.Entry

    var body: some View {
        VStack(spacing: 10) {
            Image(systemName: entry.time.icon)
                .imageScale(.large)
                .foregroundColor(.red)
            HStack {
                Text("\(entry.time.text)好")
            }
            .font(.title3)
        }
        .widgetBackground(Color.white)
    }
}

struct TodayWidget: Widget {
    let kind: String = "TodayWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: TodayProvider()) { entry in
            TodayWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("时间状态小组件")
        .description("This is an example widget.")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

//#Preview(as: .systemSmall) {
//    TextWidget()
//} timeline: {
//    TodayEntry(date: .now, time: .morning)
//}

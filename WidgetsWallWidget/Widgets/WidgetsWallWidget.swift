//
//  WidgetsWallWidget.swift
//  WidgetsWallWidget
//
//  Created by on 2024/10/17.
//

import WidgetKit
import SwiftUI
import AudioToolbox
import AppIntents


func vibrate() {
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
}

struct MyCalculateIntent: AppIntent {
    // 标题
    static var title: LocalizedStringResource = "点击震动"
    // 描述
    static var description: IntentDescription = IntentDescription("点击震动")
    
    // 计算结果,结果存储到全局
    func perform() async throws -> some IntentResult {
        vibrate()
        return .result()
    }
}

@available(iOSApplicationExtension 17.0, *)
struct Provider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: ConfigurationAppIntent())
    }

    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: configuration)
    }
    
    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<SimpleEntry> {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, configuration: configuration)
            entries.append(entry)
        }

        return Timeline(entries: entries, policy: .atEnd)
    }
}

@available(iOSApplicationExtension 17.0, *)
struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationAppIntent
}

@available(iOSApplicationExtension 17.0, *)
struct WidgetsWallWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        VStack {
            Text("Time:")
            Text(entry.date, style: .time)

            Button(intent: MyCalculateIntent()) {
                Text("按钮点击")
            }

        }
    }
}

@available(iOSApplicationExtension 17.0, *)
struct WidgetsWallWidget: Widget {
    let kind: String = "WidgetsWallWidget"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: ConfigurationAppIntent.self, provider: Provider()) { entry in
            WidgetsWallWidgetEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
        .supportedFamilies([.systemMedium])
    }
}

@available(iOSApplicationExtension 17.0, *)
extension ConfigurationAppIntent {
    fileprivate static var smiley: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
        intent.favoriteEmoji = "😀"
        return intent
    }
    
    fileprivate static var starEyes: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
        intent.favoriteEmoji = "🤩"
        return intent
    }
}

//#Preview(as: .systemMedium) {
//    WidgetsWallWidget()
//} timeline: {
//    SimpleEntry(date: .now, configuration: .smiley)
//    SimpleEntry(date: .now, configuration: .starEyes)
//}

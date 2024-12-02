//
//  RotateWidget.swift
//  WidgetsWallWidgetExtension
//
//

import WidgetKit
import SwiftUI
import AppIntents
import ClockHandRotationKit

// 全局旋转状态
var isRotating = false
// 全局旋转角度
var currentAngle: Double = 0
var currentAngleEnabled = false

private func tick(_ duration: TimeInterval) {
    DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
        if (!currentAngleEnabled) {
            return
        }
        withAnimation(.easeInOut(duration: 1.0)) {
            currentAngle += 90 // 每次旋转90度
        }
        WidgetCenter.shared.reloadAllTimelines()
        tick(duration)
    }
}

struct RotateAnimateIntent: AppIntent {
    static var title: LocalizedStringResource = "旋转按钮"
    
    func perform() async throws -> some IntentResult {
        currentAngleEnabled = !currentAngleEnabled
        tick(0.25)
        return .result()
    }
}

struct RotateIntent: AppIntent {
    static var title: LocalizedStringResource = "旋转按钮"
    
    func perform() async throws -> some IntentResult {
        isRotating = !isRotating
        return .result()
    }
}

struct RotateProvider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> RotateEntry {
        RotateEntry(date: Date())
    }

    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> RotateEntry {
        RotateEntry(date: Date())
    }
    
    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<RotateEntry> {
        var entries: [RotateEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = RotateEntry(date: entryDate)
            entries.append(entry)
        }

        return Timeline(entries: entries, policy: .atEnd)
    }
}

struct RotateEntry: TimelineEntry {
    let date: Date
}

struct RectangleView2: View {
    var body: some View {
        ZStack(alignment: .center) {
            Rectangle()
                .frame(width: 75*2, height: 30)
                .foregroundColor(.blue.opacity(0.1)) // 作者的代码透明度为0

            Rectangle()
                .frame(width: 90, height: 30)
                .foregroundColor(.black.opacity(0.1)) // 作者的代码透明度为0
                .offset(x: 75 / 2 + 7.5)

            Rectangle()
                .frame(width: 30, height: 30)
                .foregroundColor(.black.opacity(1))
                .modifier(ClockHandRotationModifier(period: ClockHandRotationPeriod.custom(-10), timeZone: TimeZone.current, anchor: .center))
                .offset(x: 75)

            Color.white
                .frame(width: 1, height: 1)
                .foregroundColor(.white)
        }
        .modifier(ClockHandRotationModifier(period: .custom(5), timeZone: TimeZone.current, anchor: .center))
    }
}

struct RectangleView1: View {
    var body: some View {
        ZStack(alignment: .center) {
            Rectangle()
                .frame(width: 150, height: 30)
                .foregroundColor(.red.opacity(0.1)) // 作者的代码透明度为0

            Color.white
                .frame(width: 1, height: 1)
                .foregroundColor(.white)
        }
    }
}

struct RotateAnimate: View {
    var body: some View {
        VStack {
            Image(systemName: "clock")
                .resizable()
                .frame(width: 50, height: 50)
                .rotationEffect(Angle(degrees: currentAngle))
            
            Button(intent: RotateAnimateIntent()) {
                Text("旋转按钮")
            }
        }
    }
}

struct RotateAnimate2: View {
    var body: some View {
        VStack {
            // 旋转动画
            if (isRotating) {
                Image(systemName: "arrow.clockwise")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 50, height: 50)
                    .clockHandRotationEffect(period: .custom(1), in: TimeZone.current, anchor: .top)
            } else {
                Image(systemName: "arrow.clockwise")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 50, height: 50)
            }
            
            Button(intent: RotateIntent()) {
                Text("旋转按钮")
            }
        }
    }
}

struct RotateAnimate3: View {
    var body: some View {
        ZStack {
            Rectangle()
                .frame(width: 340, height: 1)
                .foregroundColor(.red.opacity(1))
            ZStack {
                RectangleView1()
                RectangleView2().offset(x: 75)
            }
            .modifier(ClockHandRotationModifier(period: .custom(-10), timeZone: TimeZone.current, anchor: .center))
        }
    }
}

struct RotateAnimate4: View {
    var body: some View {
        // 文字翻转
        Text("ClockRotationEffect")
            .modifier(ClockHandRotationModifier(period: .secondHand, timeZone: TimeZone.current, anchor: .center))
    }
}



struct RotateWidgetEntryView : View {
    var entry: RotateProvider.Entry

    var body: some View {
        // 自定义旋转动画
        // RotateAnimate()
        
        RotateAnimate2()
        
        // RotateAnimate3()
        
        // RotateAnimate4()
    }
}

struct RotateWidget: Widget {
    let kind: String = "RotateWidget"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: ConfigurationAppIntent.self, provider: RotateProvider()) { entry in
            RotateWidgetEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
        .supportedFamilies([.systemMedium])
    }
}

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

//
//  TimeNotifityLiveActivity.swift
//  WidgetsWallWidgetExtension
//
//  Created by on 2024/10/17.
//

import SwiftUI
import WidgetKit
import ActivityKit

struct NotifityLiveActivityView: View {
    let context: ActivityViewContext<TimeNotifityAttributes>
    
    var body: some View {
        VStack {
            Spacer(minLength: 10)
            HStack {
                Text("\(context.state.emoji) \(context.state.title)")
            }
            Spacer(minLength: 0)
            NotifityLiveActivityProgressView(progress: context.state.progress)
            Spacer(minLength: 10)
        }
    }
}

struct NotifityLiveActivityProgressView: View {
    var progress: Float
    let borderOffset = 20.0
    
    var body: some View {
        VStack {
            Spacer(minLength: 0)
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 5)
                    .foregroundColor(Color.gray)
                    .frame(height: 10)
                
                RoundedRectangle(cornerRadius: 5)
                    .foregroundColor(Color.yellow)
                    .frame(width: (UIScreen.main.bounds.width - borderOffset * 3) * Double(progress), height: 10)
            }
            .frame(height: 15)
            .padding(.horizontal, borderOffset)
        }
    }
}

struct TimeNotifityLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: TimeNotifityAttributes.self) { context in
            // 实时通知
            NotifityLiveActivityView(context: context)
        } dynamicIsland: { context in
            DynamicIsland {
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Bottom \(context.state.emoji)")
                    Text("内容：\(context.attributes.name) 自定义内容")
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T \(context.state.emoji)")
            } minimal: {
                Text(context.state.emoji)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

//
//  WidgetsWallWidgetLiveActivity.swift
//  WidgetsWallWidget
//
//  Created by on 2024/10/17.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct WidgetsWallWidgetAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct WidgetsWallWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: WidgetsWallWidgetAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                Text("Hello \(context.state.emoji)")
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Bottom \(context.state.emoji)")
                    // more content
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

extension WidgetsWallWidgetAttributes {
    fileprivate static var preview: WidgetsWallWidgetAttributes {
        WidgetsWallWidgetAttributes(name: "World")
    }
}

extension WidgetsWallWidgetAttributes.ContentState {
    fileprivate static var smiley: WidgetsWallWidgetAttributes.ContentState {
        WidgetsWallWidgetAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: WidgetsWallWidgetAttributes.ContentState {
         WidgetsWallWidgetAttributes.ContentState(emoji: "🤩")
     }
}

//#Preview("Notification", as: .content, using: WidgetsWallWidgetAttributes.preview) {
//   WidgetsWallWidgetLiveActivity()
//} contentStates: {
//    WidgetsWallWidgetAttributes.ContentState.smiley
//    WidgetsWallWidgetAttributes.ContentState.starEyes
//}

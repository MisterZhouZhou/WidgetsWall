//
//  CommonProvider.swift
//  WidgetsWallWidgetExtension
//
//  Created by on 2024/10/17.
//

import WidgetKit

struct CommonEntry: TimelineEntry {
    let date: Date
}


struct CommonProvider: TimelineProvider {
    func placeholder(in context: Context) -> CommonEntry {
        CommonEntry(date: Date())
    }

    func getSnapshot(in context: Context, completion: @escaping (CommonEntry) -> ()) {
        let entry = CommonEntry(date: Date())
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [CommonEntry] = []
        let currentDate = Date()
        let entry = CommonEntry(date: currentDate)
        entries.append(entry)

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

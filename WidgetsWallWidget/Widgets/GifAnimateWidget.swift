//
//  GifAnimateWidget.swift
//  WidgetsWallWidgetExtension
//
//  Created by on 2024/10/17.
//  Gif动画 小组件

import SwiftUI
import WidgetKit

struct GifAnimateWidgetEntryView : View {
    var entry: CommonProvider.Entry

    var body: some View {
        VStack(alignment: .leading) {
            VStack(alignment: .leading, spacing: 0) {
                Text(dateInfo.day)
                    .font(.custom("DINAlternate-Bold", size: 28))
                    .foregroundColor(.white)
                + Text(" / \(dateInfo.month)")
                    .font(.custom("DINAlternate-Bold", size: 14))
                    .foregroundColor(.white)
                Text("\(dateInfo.year), \(dateInfo.weekday)")
                    .font(.custom("PingFangSC", size: 10))
                    .foregroundColor(.white.opacity(0.9))
            }
            
            Spacer()
            
            Text("不与伪君子争名，不与真小人争利")
                .font(.custom("PingFangSC", size: 14))
                .foregroundColor(.white)
                .lineSpacing(4)
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .baseShadow()
        .padding(.horizontal, 14)
        .padding(.top, 13)
        .padding(.bottom, 18)
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
        .background(
            Color.black.opacity(0.15)
        )
        .background(
            GifImageView(gifName: "transformer", defaultImage: "")
        )
    }
}

struct GifAnimateWidget: Widget {
    let kind: String = "GifAnimateWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: CommonProvider()) { entry in
            GifAnimateWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Gif动画小组件")
        .description("This is an example widget.")
        .supportedFamilies([.systemSmall])
        .adoptableWidgetContentMargin()
    }
}

//#Preview(as: .systemSmall) {
//    GifAnimateWidget()
//} timeline: {
//   CommonEntry(date: .now)
//}

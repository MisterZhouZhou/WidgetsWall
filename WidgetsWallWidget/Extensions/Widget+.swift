//
//  Widget_Extension.swift
//  WidgetsWallWidgetExtension
//
//  Created by on 2024/10/17.
//

import SwiftUI

extension View {
    // 背景
    @ViewBuilder
    func widgetBackground(_ backgroundView: some View) -> some View {
        if #available(iOS 17.0, *) {
            containerBackground(for: .widget) {
                backgroundView
            }
        } else {
            background(backgroundView)
        }
    }
}

extension WidgetConfiguration {
    // 是否允许content margin
    func adoptableWidgetContentMargin() -> some WidgetConfiguration {
        if #available(iOSApplicationExtension 15.0, *) {
            print("15.0 以上系统")
            return contentMarginsDisabled()
        } else {
            print("15.0 以下系统")
            return self
        }
    }
}

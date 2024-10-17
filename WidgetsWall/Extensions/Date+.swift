//
//  Date+.swift
//  WidgetsWall
//
//  Created by on 2024/10/17.
//

import Foundation

struct DateInfo {
    var year: String
    var month: String
    var day: String
    var weekday: String
}

var dateInfo: DateInfo {
    let calendar = Calendar.current
    let components = calendar.dateComponents([.year, .month, .day, .weekday], from: Date())

    let year = "\(components.year!)"
    let month = Months[components.month! - 1]
    let day = "\(components.day!)"
    let weekday = ShotWeekdays[components.weekday! - 1] // 星期几（注意，周日是“1”，周一是“2”。。。。）
    return DateInfo(year: year, month: month, day: day, weekday: weekday)
}

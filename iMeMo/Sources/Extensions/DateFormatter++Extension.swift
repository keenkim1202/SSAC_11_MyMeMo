//
//  DateFormatter++Extension.swift
//  iMeMo
//
//  Created by KEEN on 2021/11/11.
//

import Foundation

extension DateFormatter {
  static var etcFormat: DateFormatter { // 그 외의 기간
    let df = DateFormatter()
    df.locale = Locale(identifier: "Ko_kr")
    df.dateFormat = "yyyy.MM.dd a hh:mm"
    return df
  }
  
  static var weekdayFormat: DateFormatter { // 이번주
    let df = DateFormatter()
    df.locale = Locale(identifier: "Ko_kr")
    df.dateFormat = "EEEE"
    return df
  }
  
  static var todayFormat: DateFormatter { // 오늘
    let df = DateFormatter()
    df.locale = Locale(identifier: "Ko_kr")
    df.dateFormat = "a hh:mm"
    return df
  }
  
  static func setDateFormat(of date: Date) -> String {
    let today = Calendar.current.dateComponents([.year, .month, .day, .weekOfMonth], from: Date())
    let subject = Calendar.current.dateComponents([.year, .month, .day, .weekOfMonth], from: date)
    
    if (today.year == subject.year) && (today.month == subject.month) {
      if today.day == subject.day {
        return todayFormat.string(from: date)
      }
      else if today.weekOfMonth == subject.weekOfMonth {
        return weekdayFormat.string(from: date)
      }
    }
    return etcFormat.string(from: date)
  }
}

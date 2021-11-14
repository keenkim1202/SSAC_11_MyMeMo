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
    let date = DateFormatter()
    date.locale = Locale(identifier: "Ko_kr")
    date.dateFormat = "EEEE"
    return date
  }
  
  static var todayFormat: DateFormatter { // 오늘
    let date = DateFormatter()
    date.locale = Locale(identifier: "Ko_kr")
    date.dateFormat = "a hh:mm"
    return date
  }
}

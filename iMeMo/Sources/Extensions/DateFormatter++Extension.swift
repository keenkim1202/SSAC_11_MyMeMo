//
//  DateFormatter++Extension.swift
//  iMeMo
//
//  Created by KEEN on 2021/11/11.
//

import Foundation

extension DateFormatter {
  static var customFormat: DateFormatter {
    let date = DateFormatter()
    date.dateFormat = "yyyy.MM.dd a hh:mm"
    return date
  }
}

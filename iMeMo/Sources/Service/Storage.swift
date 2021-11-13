//
//  Storage.swift
//  iMeMo
//
//  Created by KEEN on 2021/11/10.
//

import Foundation

public class Storage {
  static func isFirstTime() -> Bool {
    let defaults = UserDefaults.standard
    if defaults.object(forKey: "isFirstTime") == nil {
      defaults.set("No", forKey:"isFirstTime")
      return true
    } else {
      return false
    }
  }
}

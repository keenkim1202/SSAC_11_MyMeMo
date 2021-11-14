//
//  UIColor++Extension.swift
//  iMeMo
//
//  Created by KEEN on 2021/11/14.
//

import UIKit

enum AssetsColor {
  case cellBackgroundColor // cell 배경 색
  case headerTextColor // header 글자 색
  case mainColor // navigationBar 등에서 사용될 mainColor
  case subTextColor // 메모의 subtitle 글자 섹
}



extension UIColor {
  public class var cellBackgroundColor: UIColor {
    return UIColor(named: "CellBackgroundColor")!
  }
  
  public class var headerTextColor: UIColor {
    return UIColor(named: "HeaderTextColor")!
  }
  
  public class var mainColor: UIColor {
    return UIColor(named: "MainColor")!
  }
  
  public class var subTextColor: UIColor {
    return UIColor(named: "SubTextColor")!
  }
  
//  static func appColor(_ name: AssetsColor) -> UIColor {
//    switch name {
//    case .cellBackgroundColor: return UIColor(named: "CellBackgroundColor")!
//    case .headerTextColor: return UIColor(named: "HeaderTextColor")!
//    case .mainColor: return UIColor(named: "MainColor")!
//    case .subTextColor: return UIColor(named: "SubTextColor")!
//    }
//  }
}

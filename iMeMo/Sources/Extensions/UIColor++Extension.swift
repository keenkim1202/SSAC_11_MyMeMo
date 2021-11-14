//
//  UIColor++Extension.swift
//  iMeMo
//
//  Created by KEEN on 2021/11/14.
//

import UIKit

extension UIColor {
  public class var cellBackgroundColor: UIColor {  // cell 배경 색
    return UIColor(named: "CellBackgroundColor")!
  }
  
  public class var headerTextColor: UIColor { // header 글자 색
    return UIColor(named: "HeaderTextColor")!
  }
  
  public class var mainColor: UIColor { // navigationBar 등에서 사용될 mainColor
    return UIColor(named: "MainColor")!
  }
  
  public class var subTextColor: UIColor { // 메모의 subtitle 글자 섹
    return UIColor(named: "SubTextColor")!
  }
}

//
//  UILabel++Extension.swift
//  iMeMo
//
//  Created by KEEN on 2021/11/15.
//

import UIKit

extension UILabel {
  func highlightKeyword(text: String) {
    guard let texts = self.text else { return }
    
    do {
      let mutableAttrStr = NSMutableAttributedString(string: texts)
      let regex = try NSRegularExpression(pattern: text, options: .caseInsensitive)
      
      for match in regex.matches(
        in: texts,
        options: NSRegularExpression.MatchingOptions(rawValue: 0),
        range: NSRange(location: 0, length: texts.utf16.count)
      ) as [NSTextCheckingResult] {
        mutableAttrStr.addAttribute(
          NSAttributedString.Key.foregroundColor,
          value: UIColor.mainColor,
          range: match.range
        )
      }
      self.attributedText = mutableAttrStr
    } catch {
      print("hightlightKeyword ERROR - ", error)
    }
  }
}

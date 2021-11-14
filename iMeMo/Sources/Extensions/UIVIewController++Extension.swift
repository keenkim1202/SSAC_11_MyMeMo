//
//  Alert++Extension.swift
//  iMeMo
//
//  Created by KEEN on 2021/11/14.
//

import UIKit

extension UIViewController {
  
  typealias CompletionHandler = () -> ()
  
  func deleteAlert(_ message: String, completion: @escaping CompletionHandler) {
    let alert = UIAlertController(title: "⚠️", message: message, preferredStyle: .alert)
    let no = UIAlertAction(title: "아니오", style: .default, handler: nil)
    let yes = UIAlertAction(title: "네", style: .destructive) { _ in
      completion()
    }
    alert.addAction(no)
    alert.addAction(yes)
    
    self.present(alert, animated: true, completion: nil)
  }
  
  func maximumPinAlert(_ message: String) {
    let alert = UIAlertController(title: "📌", message: message, preferredStyle: .alert)
    let ok = UIAlertAction(title: "확인", style: .destructive, handler: nil)
    alert.addAction(ok)
    
    self.present(alert, animated: true, completion: nil)
  }
}

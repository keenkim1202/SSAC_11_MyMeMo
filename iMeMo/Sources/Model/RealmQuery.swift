//
//  RealmQuery.swift
//  iMeMo
//
//  Created by KEEN on 2021/11/12.
//

import UIKit
import RealmSwift

extension UIViewController {
  // MARK: - Method
  func searchQuryFromUserDiary(q: String) -> Results<Memo> {  // 원하는 메모 가져오기
    let localRealm = try! Realm()
    let search = localRealm.objects(Memo.self).filter("title CONTAINTS[c] '\(q)' OR content CONTAINTS[c] '\(q)'")
    
    return search
  }
  
  func getAllDiaryCountFromUserDiary() -> Int {
    let localRealm = try! Realm()
    return localRealm.objects(Memo.self).count
  }
}

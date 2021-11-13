//
//  RepositoryServiceType.swift
//  iMeMo
//
//  Created by KEEN on 2021/11/13.
//

import Foundation
import Realm
import RealmSwift

protocol RepositoryServiceType {
  var count: Int { get }
  
  func add(item: Memo)
  func update(item: Memo, newMemo: Memo)
  func remove(item: Memo)
  func removeEmpty(item: Memo)
  func fetch(type: MemoType) -> [Memo]
  func search(query: String) -> Results<Memo>
  func pin(item: Memo)
  func cleanUp()
}

final class RepositoryService: RepositoryServiceType {
  
  static let shared = RepositoryService()
  private let localRealm = try! Realm()
  
  init() {
    print("Realm Location: ", localRealm.configuration.fileURL ?? "cannot find locaation.")
//    print(localRealm.objects(Memo.self).filter("isEnable == true"))
  }

  var count: Int {
    return localRealm.objects(Memo.self).filter("isEnable == true").count
  }
  
  func add(item: Memo) {
    try! localRealm.write {
      localRealm.add(item)
    }
  }
  
  func update(item: Memo, newMemo: Memo) {
    try! localRealm.write {
      localRealm.create(
        Memo.self,
        value: ["_id": item._id,
                "title": newMemo.title,
                "content": newMemo.content ?? "추가 텍스트 없음",
                "writtenDate": Date(),
                ],
        update: .modified
      )
    }
  }
  
  func remove(item: Memo) {
    try! localRealm.write {
      item.isEnable = false
    }
  }
  
  func removeEmpty(item: Memo) {
    let objects = localRealm.objects(Memo.self).filter("title == '' AND content == nil")
    objects.forEach {
      remove(item: $0)
    }
  }
  
  func fetch(type: MemoType) -> [Memo] {
    return localRealm.objects(Memo.self)
      .filter("isEnable == true")
      .filter("isPinned == \(type.rawValue)")
      .sorted(byKeyPath: "writtenDate", ascending: false)
      .map{ $0 }
  }
  
  func search(query: String) -> Results<Memo> {
    let search = localRealm.objects(Memo.self)
      .filter("title CONTAINS[c] '\(query)' OR content CONTAINS[c] '\(query)'")
    return search.sorted(byKeyPath: "writtenDate", ascending: false)
  }
  
  func pin(item: Memo) {
    try! localRealm.write {
      let object = localRealm.object(ofType: Memo.self, forPrimaryKey: item._id)
      object?.isPinned.toggle()
    }
  }
  
  func cleanUp() {
    let items = localRealm.objects(Memo.self).filter("isEnable == false")
    try! localRealm.write {
      localRealm.delete(items)
    }
  }
}

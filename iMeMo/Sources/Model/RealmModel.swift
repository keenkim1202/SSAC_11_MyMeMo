//
//  RealmModel.swift
//  iMeMo
//
//  Created by KEEN on 2021/11/12.
//

import Foundation
import RealmSwift

class Memo: Object {
  @Persisted var title: String
  @Persisted var content: String?
  @Persisted var writtenDate: Date
  @Persisted var isPinned: Bool

  @Persisted(primaryKey: true) var _id: ObjectId
  
  convenience init(title: String, content: String?, writtenDate: Date) {
    self.init()
    
    self.title = title
    self.content = content
    self.writtenDate = Date()
    self.isPinned = false
  }
}

//
//  AddViewController.swift
//  iMeMo
//
//  Created by KEEN on 2021/11/11.
//

import UIKit
import RealmSwift

class AddViewController: UIViewController {
  
  // MARK: Enum
  enum ViewType {
    case add
    case update
  }
  
  // MARK: Properties
  let localRealm = try! Realm()
  var viewType: ViewType = .add
  var memo: Memo?
  
  let formatter:  DateFormatter = {
    let df = DateFormatter()
    df.dateFormat = "yyyy년 MM월 dd일"
    return df
  }()
  
  // MARK: UI
  @IBOutlet weak var textView: UITextView!
  
  // MARK: View Life-Cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    textView.delegate = self
    configureNAV()
  }
  
  // MARK: Configure
  func configureNAV() {
    let shareBarButton = UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.up"), style: .plain, target: self, action: #selector(onShare))
    let doneBarButton = UIBarButtonItem(title: "완료", style: .plain, target: self, action: #selector(onDone))
    navigationItem.rightBarButtonItems = [doneBarButton, shareBarButton]
    
    if let memo = memo {
      viewType = .update
      title = "메모 수정"
      textView.text = "\(memo.title)\n\(memo.content!)"
    } else {
      title = "메모 작성"
      textView.becomeFirstResponder()
    }
  }
  
  // MARK: Actions
  @objc func onShare() {
    print("share button tapped.")
  }
  
  @objc func onDone() {
    if !textView.text.isEmpty {
      let text = textView.text.trimmingCharacters(in: .newlines).components(separatedBy: "\n")
      let title = text.first!
      let content = String(textView.text.dropFirst(title.count + 1)) // 개행 포함
      
      let task = Memo(title: title, content: content, writtenDate: Date())
      
      if viewType == .update {
        try! localRealm.write {
          localRealm.create(
            Memo.self,
            value: ["_id": memo!._id,
                    "title": task.title,
                    "content": task.content ?? "추가 텍스트 없음",
                    "writtenDate": Date(),
                    ],
            update: .modified
          )
        }
      } else {
        try! localRealm.write {
          localRealm.add(task)
        }
      }
    } else {
      // TODO: 메모의 내용이 비어있으면 메모 삭제하기
    }
    self.navigationController?.popViewController(animated: true)
  }
}

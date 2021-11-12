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
      textView.text = memo.title + memo.content!
    } else {
      title = "메모 작성"
    }
  }
  
  // MARK: Actions
  @objc func onShare() {
    print("share button tapped.")
  }
  
  @objc func onDone() {
    
    let text = textView.text.components(separatedBy: "\n")
    let title = text[0]
    let content = text[1...].joined()
    
    let task = Memo(title: title, content: content, writtenDate: Date())
    
    if viewType == .update {
      try! localRealm.write {
        localRealm.create(
          Memo.self,
          value: ["_id": memo!._id,
                  "title": task.title,
                  "content": task.content ?? "내용 없음",
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
    self.navigationController?.popViewController(animated: true)
  }
  
}

// MARK: - Extension - TextViewDelegate
extension AddViewController: UITextViewDelegate {
  
}

//
//  AddViewController.swift
//  iMeMo
//
//  Created by KEEN on 2021/11/11.
//

import UIKit
import RealmSwift

class AddViewController: UIViewController {
  
  // MARK: - Enum
  enum ViewType: String {
    case add = "메모 추가"
    case update = "메모 수정"
  }
  
  // MARK: - Properties
  var viewType: ViewType = .add
  var memo: Memo? = nil
  var isRightBarbuttonsEnable: Bool = false
  
  // MARK: - UI
  @IBOutlet weak var textView: UITextView!
  
  // MARK: - View Life-Cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    textView.delegate = self
    configureNAV()
    configureMemo()
  }
  
  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(true)
    saveData()
  }
  
  // MARK: - Configure
  func configureNAV() {
    self.navigationController?.navigationBar.prefersLargeTitles = false
    
    // bar items
    let shareBarButton = UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.up"), style: .plain, target: self, action: #selector(onShare))
    let doneBarButton = UIBarButtonItem(title: "완료", style: .plain, target: self, action: #selector(onDone))
    
    if isRightBarbuttonsEnable {
      shareBarButton.isEnabled = true
      doneBarButton.isEnabled = true
      shareBarButton.tintColor = UIColor(named: "MainGreenColor")
      doneBarButton.tintColor = UIColor(named: "MainGreenColor")
    } else {
      shareBarButton.isEnabled = false
      doneBarButton.isEnabled = false
      shareBarButton.tintColor = UIColor.darkGray
      doneBarButton.tintColor = UIColor.darkGray
    }
    
    // title
    navigationItem.rightBarButtonItems = [doneBarButton, shareBarButton]
    title = viewType.rawValue
  }
  
  func configureMemo() {
    if let memo = memo {
      viewType = .update
      textView.text = "\(memo.title)\n\(memo.content!)"
    } else {
      textView.becomeFirstResponder()
    }
  }
  
  func getMemoStrings(newText: String) -> (title: String, content: String) {
    let text = newText.trimmingCharacters(in: .newlines).components(separatedBy: "\n")
    let title = text.first!
    let content = String(newText.dropFirst(title.count + 1))
    
    return (title, content)
  }
  
  func saveData() {
    print("save data...")
    
    if !textView.text.isEmpty {
      let memoStrings = getMemoStrings(newText: textView.text)
      let newMemo = Memo(title: memoStrings.title, content: memoStrings.content)
      
      if viewType == .update {
        guard let memo = self.memo else { return }
        print("gonna update")
        RepositoryService.shared.update(item: memo, newMemo: newMemo)
      } else {
        print("gonna add")
        RepositoryService.shared.add(item: newMemo)
      }
    } else {
      // TODO: 메모의 내용이 비어있으면 메모 삭제하기
      guard let memo = self.memo else { return }
      RepositoryService.shared.removeEmpty(item: memo)
    }
    print("save end..")
  }
  
  // MARK: - Actions
  @objc func onShare() {
    print("share button tapped.")
  }
  
  @objc func onDone() {
    self.navigationController?.popViewController(animated: true)
  }
}

// MARK: - Extension
// MARK: - UITextViewDelegate -
extension AddViewController: UITextViewDelegate {  
  func textViewDidBeginEditing(_ textView: UITextView) {
    isRightBarbuttonsEnable = true
    configureNAV()
  }
  
  func textViewDidEndEditing(_ textView: UITextView) {
    isRightBarbuttonsEnable = false
    configureNAV()
  }
}

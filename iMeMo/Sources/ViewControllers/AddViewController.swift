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
    
    [shareBarButton, doneBarButton].forEach {
      if isRightBarbuttonsEnable {
        $0.isEnabled = true
        $0.tintColor = UIColor(named: "MainGreenColor")
      } else {
        $0.isEnabled = false
        $0.tintColor = UIColor.darkGray
      }
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
    if !textView.text.isEmpty {
      let memoStrings = getMemoStrings(newText: textView.text)
      let newMemo = Memo(title: memoStrings.title, content: memoStrings.content)
      
      if viewType == .update {
        guard let memo = self.memo else { return }
        RepositoryService.shared.update(item: memo, newMemo: newMemo)
      } else {
        RepositoryService.shared.add(item: newMemo)
      }
    } else {
      guard let memo = self.memo else { return }
      RepositoryService.shared.removeEmpty(item: memo)
    }
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

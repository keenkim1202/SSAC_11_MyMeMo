//
//  SearchViewController.swift
//  iMeMo
//
//  Created by KEEN on 2021/11/12.
//

import UIKit
import RealmSwift

class SearchViewController: UIViewController {
  
  // MARK: - Metric
  struct Metric {
    static let fontSize: CGFloat = 20
  }
  
  // MARK: - Properties
  var queryText: String = "" {
    didSet { results = RepositoryService.shared.search(query: queryText) }
  }

  var results: Results<Memo>? {
    didSet { searchTableView.reloadData() }
  }
  
  // MARK: - UI
  @IBOutlet weak var searchTableView: UITableView!
  
  let resultLabel: UILabel = {
    let l = UILabel()
    l.font = UIFont.boldSystemFont(ofSize: Metric.fontSize)
    return l
  }()
  
  // MARK: - View Life-Cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    searchTableView.delegate = self
    searchTableView.dataSource = self
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(true)
    
    reloadData()
    searchTableView.reloadData()
  }
  
  func reloadData() {
    results = RepositoryService.shared.search(query: queryText)
  }
  
  // MARK: Swipe Actions
  func deleteAction(at indexPath: IndexPath) -> UIContextualAction {
    let action = UIContextualAction(style: .destructive, title: "삭제") { action, view, success in
      
      guard let results = self.results else { return }
      self.deleteAlert("정말 삭제하시겠습니까?") {
        
        let memo = results[indexPath.row]
        RepositoryService.shared.remove(item: memo)
        self.searchTableView.reloadData()
      }
      
      self.searchTableView.reloadData()
      success(true)
    }
    action.image = UIImage(systemName: "trash")
    action.backgroundColor = .systemRed
    
    return action
  }
  
  func pinAction(at indexPath: IndexPath) -> UIContextualAction {
    guard let results = self.results else { return UIContextualAction() }
    
    let action = UIContextualAction(style: .normal, title: "pin") { action, view, success in
      let pinnedCount = results.filter("isPinned == true").count
      guard pinnedCount < 5 else {
        self.maximumPinAlert("더 이상 고정할 수 없습니다.\n고정메모는 최대 5개까지 등록할 수 있습니다.")
        return
      }
      let memo = results[indexPath.row]
      RepositoryService.shared.pin(item: memo)
      
      self.searchTableView.reloadData()
      success(true)
    }
    
    let isPinned = results[indexPath.row].isPinned
    action.image = isPinned ? UIImage(systemName: "pin.fill") : UIImage(systemName: "pin")
    action.backgroundColor = UIColor.mainColor
    
    return action
  }
}

// MARK: Extension
// MARK: - UITableViewDelegate -
extension SearchViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    guard let results = results else { return nil }
    
    resultLabel.text = "\(results.count)개 찾음"
    return resultLabel
  }
  
  // MARK: - cell 선택시 이동 관련
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let contentStoryboard = UIStoryboard.init(name: "Content", bundle: nil)
    guard let vc = contentStoryboard.instantiateViewController(withIdentifier: "addVC") as? AddViewController else { return }
    
    guard let results = results else { return }
    let selectedMemo = results[indexPath.row]
    vc.memo = selectedMemo
    vc.viewType = .update
    
    presentingViewController?.navigationController?.pushViewController(vc, animated: true)
  }
  
  // MARK: - Swipe Action 설정
  // leading에서 스와이프
  func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
    let pin = pinAction(at: indexPath)
    return UISwipeActionsConfiguration(actions:[pin])
  }
  
  // trailing에서 스와이프
  func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
    let delete = deleteAction(at: indexPath)
    return UISwipeActionsConfiguration(actions:[delete])
  }
  
}

// MARK: - UITableViewDataSource -
extension SearchViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return results != nil ? results!.count : 0
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchTableViewCell.identifier) as? SearchTableViewCell else { return UITableViewCell() }
    guard let results = results else { return UITableViewCell() }
    
    let row = results[indexPath.row]
    cell.cellConfigure(with: row, query: queryText)
    return cell
  }
}

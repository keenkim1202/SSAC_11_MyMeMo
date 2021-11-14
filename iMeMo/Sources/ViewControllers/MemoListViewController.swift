//
//  ViewController.swift
//  iMeMo
//
//  Created by KEEN on 2021/11/10.
//

// TODO: 오늘, 이번주, 그 외에 따라 날짜 정보 표시 다르게 하기
// TODO: 실시간 검색 시, 검색어(queryText) 색상 바꾸기 - 참고해보자(https://zeddios.tistory.com/462)

import UIKit
import RealmSwift

class MemoListViewController: UIViewController {
  
  // MARK: - Metric
  struct Metric {
    static let cellHeight: CGFloat = 70
    static let headerFontSize: CGFloat = 20
  }
  
  // MARK: - Porperties
  var memo: Memo? = nil
  var memoCount: Int = 0
  let sectionList: [String] = ["고정된 메모", "메모"]
  
  var pinnedMemos: [Memo] = [] {
    didSet { self.tableView.reloadSections(IndexSet(integer: 0), with: .fade) }
  }
  var normalMemos: [Memo] = [] {
    didSet { self.tableView.reloadSections(IndexSet(integer: 1), with: .fade) }
  }

  // MARK: - UI
  @IBOutlet weak var tableView: UITableView!
  
  // MARK: - View Life-Cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    checkIsFirst()
    configure()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(true)
    tableView.reloadData()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(true)
    
    title = "\(RepositoryService.shared.count)개의 메모"
    reloadData()
    tableView.reloadData()
  }

  // MARK: - Configure
  func configure() {
    // navigationBar
    let storyBoard = UIStoryboard.init(name: "Search", bundle: nil)
    let searchVC = storyBoard.instantiateViewController(withIdentifier: "searchVC") as! SearchViewController
    let searchController = UISearchController(searchResultsController: searchVC)
    
    searchController.searchBar.delegate = self
    searchController.searchResultsUpdater = self
    
    self.navigationItem.searchController = searchController
    // tableView
    tableView.delegate = self
    tableView.dataSource = self
    
    reloadData()
  }
  
  func reloadData() {
    normalMemos = RepositoryService.shared.fetch(type: .normal)
    pinnedMemos = RepositoryService.shared.fetch(type: .pinned)
  }
  
  func checkIsFirst() { // 최초 실행이면 팝업 띄우기
    let isFirst = Storage.isFirstTime()
    
    if isFirst == true {
      let storyBoard = UIStoryboard.init(name: "Popup", bundle: nil)
      let popupVC = storyBoard.instantiateViewController(withIdentifier: "popupVC") as! PopupViewController
      popupVC.modalPresentationStyle = .overCurrentContext
      present(popupVC, animated: true, completion: nil)
    }
  }
  
  // MARK: Swipe Actions
  func deleteAction(at indexPath: IndexPath) -> UIContextualAction {
    let action = UIContextualAction(style: .destructive, title: "삭제") { action, view, success in
      
      self.deleteAlert("정말 삭제하시겠습니까?") {
        if indexPath.section == 0 {
          let memo = self.pinnedMemos[indexPath.row]
          RepositoryService.shared.remove(item: memo)
        } else {
          let memo = self.normalMemos[indexPath.row]
          RepositoryService.shared.remove(item: memo)
        }
        self.reloadData()
      }
      success(true)
    }
    action.image = UIImage(systemName: "trash")
    action.backgroundColor = .systemRed
    
    return action
  }

  func pinAction(at indexPath: IndexPath) -> UIContextualAction {
    let action = UIContextualAction(style: .normal, title: "pin") { action, view, success in
      
      if indexPath.section == 0 {
        let memo = self.pinnedMemos[indexPath.row]
        RepositoryService.shared.pin(item: memo)
      } else {
        guard self.pinnedMemos.count < 5 else {
          self.maximumPinAlert("더 이상 고정할 수 없습니다.\n고정메모는 최대 5개까지 등록할 수 있습니다.")
          return
        }
        let memo = self.normalMemos[indexPath.row]
        RepositoryService.shared.pin(item: memo)
      }
      self.reloadData()
      
      success(true)
    }
    action.image = indexPath.section == 0 ? UIImage(systemName: "pin.fill") : UIImage(systemName: "pin")
    action.backgroundColor = UIColor.mainColor
    
    return action
  }
  
  // MARK: - Actions
  @IBAction func onWriteButton(_ sender: UIBarButtonItem) {
    let contentStoryboard = UIStoryboard.init(name: "Content", bundle: nil)
    let vc = contentStoryboard.instantiateViewController(withIdentifier: "addVC") as! AddViewController
  
    self.navigationController?.pushViewController(vc, animated: true)
  }
}

// MARK: - Extension
// MARK: - UITableViewDelegate -
extension MemoListViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return Metric.cellHeight
  }
  
  func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
    let header = view as! UITableViewHeaderFooterView
    guard let label = header.textLabel else { return }
    
    label.font = UIFont.boldSystemFont(ofSize: Metric.headerFontSize)
    label.textColor = UIColor.headerTextColor
  }
  
  // MARK: - cell 선택시 이동 관련
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let contentStoryboard = UIStoryboard.init(name: "Content", bundle: nil)
    guard let vc = contentStoryboard.instantiateViewController(withIdentifier: "addVC") as? AddViewController else { return }
  
    if indexPath.section == 0 {
      let selectedMemo = pinnedMemos[indexPath.row]
      vc.memo = selectedMemo
      vc.viewType = .update
    } else {
      let selectedMemo = normalMemos[indexPath.row]
      vc.memo = selectedMemo
      vc.viewType = .update
    }
    self.navigationController?.pushViewController(vc, animated: true)
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
extension MemoListViewController: UITableViewDataSource {
  /// section
  func numberOfSections(in tableView: UITableView) -> Int {
    return 2
  }
  
  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return sectionList[section]
  }
  
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    if section == 0 && pinnedMemos.count == 0 {
      return CGFloat.leastNonzeroMagnitude
    }
    else {
      return tableView.sectionHeaderHeight
    }
  }
  
  func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
    if pinnedMemos.count == 0 {
      return CGFloat.leastNonzeroMagnitude
    }
    return tableView.sectionFooterHeight
  }
  
  /// row
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return section == 0 ? pinnedMemos.count : normalMemos.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: MemoListTableViewCell.identifier) as? MemoListTableViewCell else { return UITableViewCell() }
    
    if indexPath.section == 0  { // 고정된 메모
      let row = pinnedMemos[indexPath.row]
      cell.cellConfigure(with: row)
    } else {
      let row = normalMemos[indexPath.row] // 메모
      cell.cellConfigure(with: row)
    }
    return cell
  }
}

// MARK: - Extension
// MARK: - UISearchResultsUpdating -
extension MemoListViewController: UISearchResultsUpdating {
  func updateSearchResults(for searchController: UISearchController) {
    let searchVC = searchController.searchResultsController as! SearchViewController
    guard let query = searchController.searchBar.text else { return }
    
    searchVC.queryText = query
  }
}

// MARK: - UISearchBarDelegate -
extension MemoListViewController: UISearchBarDelegate {
  func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
    self.becomeFirstResponder()
  }
  func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
    reloadData()
  }
}

//
//  ViewController.swift
//  iMeMo
//
//  Created by KEEN on 2021/11/10.
//

// TODO: 오늘, 이번주, 그 외에 따라 날짜 정보 표시 다르게 하기
// TODO: 고정된 메모가 없을 때는 '고정된 메모' 섹션 보이지 않기
// TODO: 실시간 검색 시, 검색어(queryText) 색상 바꾸기 - 참고해보자(https://zeddios.tistory.com/462)
// TODO: 검색에서도 cell 클릭 시, 메모를 수정할 수 있도록 하기
// TODO: 검색에서도 cell 클릭 시, 메모를 삭제/고정 할 수 있도록 하기
// TODO: 고정 최대 갯수 5개 -> 넘길 시 alert 띄우기
// TODO: cell 삭제 시, alert 띄우기

import UIKit
import RealmSwift

class MemoListViewController: UIViewController {

  // MARK: - Porperties
  var memo: Memo? = nil
  var memoCount: Int = 0
  let sectionList: [String] = ["고정된 메모", "메모"]
  
  var pinnedMemos: [Memo] = [] {
    didSet {
      self.tableView.reloadSections(IndexSet(integer: 0), with: .fade)
    }
  }
  var normalMemos: [Memo] = [] {
    didSet {
      self.tableView.reloadSections(IndexSet(integer: 1), with: .fade)
      print("일반 메모 갯수: ", normalMemos.count)
    }
  }

  // MARK: - UI
  @IBOutlet weak var tableView: UITableView!
  
  // MARK: - View Life-Cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    checkIsFirst()
    configure()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    print(#function)
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
  
  // MARK: - Swipe Cell Action
  func deleteAction(at indexPath: IndexPath) -> UIContextualAction {
    let action = UIContextualAction(style: .destructive, title: "삭제") { action, view, success in
      
      if indexPath.section == 0 {
        let memo = self.pinnedMemos[indexPath.row]
        RepositoryService.shared.remove(item: memo)
      } else {
        let memo = self.normalMemos[indexPath.row]
        RepositoryService.shared.remove(item: memo)
      }
      self.reloadData()
      
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
        let memo = self.normalMemos[indexPath.row]
        RepositoryService.shared.pin(item: memo)
      }
      self.reloadData()
      
      success(true)
    }
    action.image = UIImage(systemName: "pin")
    action.backgroundColor = UIColor(named: "MainGreenColor")
    
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
    return 70
  }
  
  func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
    let header = view as! UITableViewHeaderFooterView
    header.textLabel?.font = UIFont.boldSystemFont(ofSize: 20)
    header.textLabel?.textColor = .white
  }
  
  // MARK: - cell 선택시 이동 관련
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let contentStoryboard = UIStoryboard.init(name: "Content", bundle: nil)
    let vc = contentStoryboard.instantiateViewController(withIdentifier: "addVC") as! AddViewController
  
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
    reloadData()
    return UISwipeActionsConfiguration(actions:[pin])
  }
  
  // trailing에서 스와이프
  func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
    let delete = deleteAction(at: indexPath)
    reloadData()
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
  func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
    reloadData()
  }
}

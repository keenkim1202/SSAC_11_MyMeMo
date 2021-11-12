//
//  ViewController.swift
//  iMeMo
//
//  Created by KEEN on 2021/11/10.
//

// TODO: 삭제하고자 하는 cell의 section에따라 row 삭제하기
// TODO: realm에 CRUD 및 검색
// TODO: 글씨를 쓰지 않을 때 키보드 dismiss 하기
// TODO: Pin action 추가하기
// TODO: 검색 기능 추가 - 실시간 검색

import UIKit
import RealmSwift

class MemoListViewController: UIViewController {

  // MARK: Realm
  let localRealm = try! Realm()
  var tasks: Results<Memo>!
  
  // MARK: Porperties
  let sectionList: [String] = ["고정된 메모", "메모"]
  let searchController = UISearchController(searchResultsController: nil)
  var pinnedMemos: [Memo] = []
  var plainMemos: [Memo] = []
  
  // MARK: UI
  @IBOutlet weak var tableView: UITableView!
  
  // MARK: View Life-Cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    configure()
  }

  // MARK: Configure
  func configure() {
    // navigationBar
    self.navigationItem.searchController = searchController
    // tableView
    tableView.delegate = self
    tableView.dataSource = self
    
    tasks = localRealm.objects(Memo.self).sorted(byKeyPath: "title", ascending: false)
    print("Realm Location: ", localRealm.configuration.fileURL ?? "cannot find locaation.")
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(true)
    
    tasks = localRealm.objects(Memo.self)
    tableView.reloadData()
  }
  
  func checkIsFirst() { // 최초 실행이면 팝업 띄우기
    let isFirst = Storage.isFirstTime()
    print(isFirst)
  }
  
  // MARK: Swipe Cell Action
  func deleteAction(at indexPath: IndexPath) -> UIContextualAction {
    let action = UIContextualAction(style: .destructive, title: "삭제") { action, view, success in
      let row = self.tasks[indexPath.row]
      
      try! self.localRealm.write {
        self.localRealm.delete(row)
        self.tableView.reloadData()
      }
      success(true)
    }
    action.image = UIImage(systemName: "trash")
    action.backgroundColor = .systemRed
    
    return action
  }
  
  // MARK: Actions
  @IBAction func onWriteButton(_ sender: UIBarButtonItem) {
    let contentStoryboard = UIStoryboard.init(name: "Content", bundle: nil)
    let vc = contentStoryboard.instantiateViewController(withIdentifier: "addVC") as! AddViewController
  
    self.navigationController?.pushViewController(vc, animated: true)
  }
  
}

// MARK: Extension
// MARK: UITableViewDelegate & UITableViewDataSource
extension MemoListViewController: UITableViewDelegate, UITableViewDataSource {
  // MARK: - section -
  func numberOfSections(in tableView: UITableView) -> Int {
    return 2
  }
  
  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return sectionList[section]
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return indexPath.section == 0 ? 50 : 70
  }

  func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
    let header = view as! UITableViewHeaderFooterView
    header.textLabel?.font = UIFont.boldSystemFont(ofSize: 20)
    header.textLabel?.textColor = .white
  }

  // MARK: - datasource 관련 -
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if section == 0 {
      return tasks.filter("isPinned == true").count
    } else {
      return tasks.filter("isPinned == false").count
    }
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: MemoListTableViewCell.identifier) as? MemoListTableViewCell else { return UITableViewCell() }
    
    let row = tasks[indexPath.row]
    
    if indexPath.section == 0 && row.isPinned == true { // 고정된 메모
      cell.titleLabel.text = row.title
      cell.subtitleLabel.text = row.content
    } else {
      let row = tasks[indexPath.row] // 메모
      cell.titleLabel.text = row.title
      cell.subtitleLabel.text = row.content
    }
    return cell
  }
  
  // MARK: - cell 선택시 이동 관련 -
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let contentStoryboard = UIStoryboard.init(name: "Content", bundle: nil)
    let vc = contentStoryboard.instantiateViewController(withIdentifier: "addVC") as! AddViewController
  
    let selectedMemo = tasks[indexPath.row]
    vc.memo = selectedMemo

    let nav = UINavigationController(rootViewController: vc)
    nav.modalPresentationStyle = .fullScreen
    self.present(nav, animated: true, completion: nil)
  }
  
  // MARK: - edit style 설정 -
//  func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
//    return true
//  }
//
//  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//  }
  
  // leading에서 스와이프
  func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
    let pin = UIContextualAction(style: .normal, title: "pin") { (action, view, success: @escaping (Bool) -> Void) in
        print("pinned")
        success(true)
    }
    pin.image = UIImage(systemName: "pin")
    pin.backgroundColor = UIColor(named: "MainGreenColor")
    
    return UISwipeActionsConfiguration(actions:[pin])
  }
  
  // trailing에서 스와이프
  func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
    let delete = deleteAction(at: indexPath)
    
    return UISwipeActionsConfiguration(actions:[delete])
  }
}

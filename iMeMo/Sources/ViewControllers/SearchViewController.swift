//
//  SearchViewController.swift
//  iMeMo
//
//  Created by KEEN on 2021/11/12.
//

import UIKit
import RealmSwift

class SearchViewController: UIViewController {
  
  // MARK: - Properties -

  var queryText: String = "" {
    didSet {
      results = RepositoryService.shared.search(query: queryText)
    }
  }
  
  var results: Results<Memo>? {
    didSet {
      searchTableView.reloadData()
    }
  }
  
  // MARK: - UI -
  @IBOutlet weak var searchTableView: UITableView!
  
  // MARK: - View Life-Cycle -
  override func viewDidLoad() {
    super.viewDidLoad()
    
  }
  
}

// MARK: Extension
// MARK: - UITableViewDelegate -
extension SearchViewController: UITableViewDelegate {
  
}

// MARK: - UITableViewDataSource -
extension SearchViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if let results = results {
      return results.count
    } else {
      return 0
    }
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchTableViewCell.identifier) as? SearchTableViewCell else { return UITableViewCell() }
    guard let results = results else { return UITableViewCell() }
    let row = results[indexPath.row]
    cell.cellConfigure(with: row)
    return cell
  }
}

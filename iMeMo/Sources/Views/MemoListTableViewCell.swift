//
//  MemoListTableViewCell.swift
//  iMeMo
//
//  Created by KEEN on 2021/11/10.
//

import UIKit

class MemoListTableViewCell: UITableViewCell {
  
  static let identifier: String = "memoListCell"

  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var subtitleLabel: UILabel!
  @IBOutlet weak var dateLabel: UILabel!
  
  func cellConfigure(with memo: Memo) {
    let dateInfo = DateFormatter.customFormat.string(from: memo.writtenDate)
    let content = memo.content ?? "추가 텍스트 없음"
    titleLabel.text = memo.title
    dateLabel.text = dateInfo
    subtitleLabel.text = content
  }
}

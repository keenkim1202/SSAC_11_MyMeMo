//
//  SearchTableViewCell.swift
//  iMeMo
//
//  Created by KEEN on 2021/11/12.
//

import UIKit

class SearchTableViewCell: UITableViewCell {

  static let identifier: String = "searchCell"
  
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var subTitleLabel: UILabel!
  
  func cellConfigure(with memo: Memo) {
    let dateInfo = DateFormatter.customFormat.string(from: memo.writtenDate)
    let content = memo.content ?? "추가 텍스트 없음"
    titleLabel.text = memo.title
    subTitleLabel.text = "\(dateInfo) \(content)"
  }
  
}

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
  @IBOutlet weak var dateLabel: UILabel!
  
  func cellConfigure(with memo: Memo, query: String) {
    let dateInfo = DateFormatter.setDateFormat(of: memo.writtenDate)
    let content = memo.content ?? "추가 텍스트 없음"
    titleLabel.text = memo.title
    dateLabel.text = dateInfo
    subTitleLabel.text = content
    
    titleLabel.highlightKeyword(text: query)
    subTitleLabel.highlightKeyword(text: query)
  }
}

//
//  PopupViewController.swift
//  iMeMo
//
//  Created by KEEN on 2021/11/12.
//

import UIKit

class PopupViewController: UIViewController {
  
  //  MARK: UI
  @IBOutlet weak var popupView: UIView!
  
  // MARK: View Life-Cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    popupView.layer.cornerRadius = CGFloat(15)
  }
  
  // MARK: Action
  @IBAction func onOKButton(_ sender: UIButton) {
    self.dismiss(animated: true, completion: nil)
  }
}

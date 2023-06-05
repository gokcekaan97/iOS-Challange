//
//  SearchAlertView.swift
//  iOS-Challange
//
//  Created by kaan gokcek on 5.06.2023.
//

import Foundation
import UIKit
import SnapKit
import Carbon

class noGameSearched: UIView {
  let noGame: UILabel = {
    let label = UILabel()
    label.font = UIFont.boldSystemFont(ofSize: 18)
    label.textAlignment = .center
    label.numberOfLines = 1
    return label
  }()
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.setupUI()
    }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func setupUI() {
    self.translatesAutoresizingMaskIntoConstraints = false
    self.addSubview(noGame)
    noGame.snp.makeConstraints { (make) in
      make.centerX.equalTo(self)
      make.height.equalTo(41)
      make.width.equalTo(244)
      make.top.equalTo(self.snp.top).offset(38)
    }
  }
}
struct noGameSearch: IdentifiableComponent {
  var title: String
  var id: String {
    title
  }
  
  func referenceSize(in bounds: CGRect) -> CGSize? {
    return CGSize(width: bounds.width, height: bounds.height)
  }
  
  func shouldContentUpdate(with next: noGameSearch) -> Bool {
    return true
  }

  func renderContent() -> noGameSearched {
    return noGameSearched()
  }

  func render(in content: noGameSearched) {
    content.noGame.text = "No game has been searched."
  }
}

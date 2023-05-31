//
//  GamesTableViewCell.swift
//  iOS-Challange
//
//  Created by kaan gokcek on 30.05.2023.
//

import Foundation
import UIKit
import Carbon
import SnapKit

class GamesView: UIView {
  let lblTitle: UILabel = {
      let v = UILabel()
      v.backgroundColor = .systemGreen
      v.textColor = .white
      v.textAlignment = .center
      v.layer.cornerRadius = 5
      v.layer.masksToBounds = true
      return v
  }()

    

  override init(frame: CGRect) {
    super.init(frame: frame)
    self.setupUI()
    }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
    func setupUI() {
      self.addSubview(lblTitle)
      lblTitle.snp.makeConstraints { (make) in
          make.top.left.equalTo(2)
          make.right.bottom.equalTo(-2)
      }
    }
}
struct GameItem: IdentifiableComponent {
  func referenceSize(in bounds: CGRect) -> CGSize? {
    return CGSize(width: bounds.width, height: 100)
  }
  
  func shouldContentUpdate(with next: GameItem) -> Bool {
    return true
  }
  
    var title: String
    var id: String {
        title
    }

    func renderContent() -> GamesView {
      return GamesView()
    }

    func render(in content: GamesView) {
      content.lblTitle.text = title
    }
}

//
//  FavouritesFound.swift
//  iOS-Challange
//
//  Created by kaan gokcek on 6.06.2023.
//

import Foundation
import UIKit
import SnapKit
import Carbon

class noFavouritedFound: UIView {
  let noFavourited: UILabel = {
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
    self.backgroundColor = .secondarySystemBackground
    self.translatesAutoresizingMaskIntoConstraints = false
    self.addSubview(noFavourited)
    noFavourited.snp.makeConstraints { (make) in
      make.centerX.equalTo(self)
      make.height.equalTo(41)
      make.width.equalTo(243)
      make.top.equalTo(self.snp.top).offset(36)
    }
  }
}
struct noFavourite: IdentifiableComponent {
  var title: String
  var id: String {
    title
  }
  
  func referenceSize(in bounds: CGRect) -> CGSize? {
    return CGSize(width: bounds.width, height: bounds.height)
  }
  
  func shouldContentUpdate(with next: noFavourite) -> Bool {
    return true
  }

  func renderContent() -> noFavouritedFound {
    return noFavouritedFound()
  }

  func render(in content: noFavouritedFound) {
    content.noFavourited.text = "There is no favourites found."
  }
}

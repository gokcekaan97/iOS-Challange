//
//  GameDetailView.swift
//  iOS-Challange
//
//  Created by kaan gokcek on 3.06.2023.
//

import Foundation
import UIKit
import SnapKit
import Carbon

class GameDetailsView: UIView {
  let gameImage = UIImageView()
  let gameDescriptionTitle: UILabel = {
    let label = UILabel()
    label.font = UIFont.systemFont(ofSize: 17)
    label.textAlignment = .left
    return label
  }()
  let gameTitle: UILabel = {
    let label = UILabel()
    label.font = UIFont.boldSystemFont(ofSize: 36)
    label.textColor = UIColor(hexString: "#FFFFFF")
    label.textAlignment = .right
    label.numberOfLines = 0
    return label
  }()
  let gameDescription: UILabel = {
    let label = UILabel()
    label.font = UIFont.systemFont(ofSize: 10, weight: .light)
    label.textAlignment = .left
    label.numberOfLines = 0
    label.translatesAutoresizingMaskIntoConstraints = false
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
    self.addSubview(gameImage)
    self.addSubview(gameDescription)
    self.addSubview(gameDescriptionTitle)
    self.addSubview(gameTitle)
    gameImage.snp.makeConstraints { (make) in
      make.top.left.right.equalToSuperview()
      make.height.equalTo(291)
    }
    gameTitle.snp.makeConstraints { make in
      make.right.equalToSuperview().inset(16)
      make.left.equalToSuperview().offset(16)
      make.bottom.equalTo(gameImage.snp.bottom).inset(16)
    }
    gameDescriptionTitle.snp.makeConstraints { make in
      make.height.equalTo(21)
      make.left.right.equalToSuperview().offset(16)
      make.top.equalTo(gameImage.snp.bottom).offset(16)
    }
    gameDescription.snp.makeConstraints { make in
      make.left.equalToSuperview().offset(16)
      make.right.equalToSuperview().inset(16)
      make.top.equalTo(gameDescriptionTitle.snp.bottom).offset(8)
      make.bottom.equalToSuperview().inset(16)
    }
  }
}
struct GameDetail: IdentifiableComponent {
  var title: String
  var description: String
  var image: URL?
  var id: String {
    title
  }
  
  func referenceSize(in bounds: CGRect) -> CGSize? {
    return CGSize(width: bounds.width, height: UITableView.automaticDimension)
  }
  
  func shouldContentUpdate(with next: GameDetail) -> Bool {
    return true
  }

  func renderContent() -> GameDetailsView {
    return GameDetailsView()
  }

  func render(in content: GameDetailsView) {
    content.gameTitle.text = title
    content.gameDescription.text = description
    content.gameDescriptionTitle.text = "Game Description"
    content.gameImage.kf.setImage(with: image)
  }
}
class GameDetailsVisitView: UIView {
  let gameVisitLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.systemFont(ofSize: 17)
    label.textAlignment = .left
    return label
  }()
  var onSelect: (() -> Void)?
  let tap = UITapGestureRecognizer()
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.setupUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  @objc func handleSelect() {
      onSelect?()
  }
  func setupUI() {
    tap.addTarget(self, action: #selector(handleSelect))
    self.addGestureRecognizer(tap)
    self.isUserInteractionEnabled = true
    self.translatesAutoresizingMaskIntoConstraints = false
    self.addSubview(gameVisitLabel)
    gameVisitLabel.snp.makeConstraints { (make) in
      make.top.left.equalToSuperview().offset(16)
      make.right.bottom.equalToSuperview().inset(16)
      make.height.equalTo(22)
    }
  }
}
struct GameDetailVisit: IdentifiableComponent {
  var title: String
  var onSelect: () -> Void
  var id: String {
    title
  }
  
  func referenceSize(in bounds: CGRect) -> CGSize? {
    return CGSize(width: bounds.width, height: 54)
  }
  
  func shouldContentUpdate(with next: GameDetailVisit) -> Bool {
    return true
  }

  func renderContent() -> GameDetailsVisitView {
    return GameDetailsVisitView()
  }

  func render(in content: GameDetailsVisitView) {
    content.gameVisitLabel.text = "Visit \(title)"
    content.onSelect = onSelect
  }
}



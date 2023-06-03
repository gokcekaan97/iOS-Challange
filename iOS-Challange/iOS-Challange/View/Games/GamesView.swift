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
import Kingfisher

class GamesView: UIView {
  let gameImage = UIImageView()
  let gameTitle: UILabel = {
    let label = UILabel()
    label.font = UIFont.boldSystemFont(ofSize: 20)
    label.textAlignment = .left
    label.numberOfLines = 0
    return label
  }()
  let gameMeta: UILabel = {
    let label = UILabel()
    label.font = UIFont.boldSystemFont(ofSize: 14)
    label.textAlignment = .left
    return label
  }()
  let gameMetaScore: UILabel = {
    let label = UILabel()
    label.font = UIFont.boldSystemFont(ofSize: 18)
    label.textColor = UIColor(hexString: "#D80000")
    label.textAlignment = .left
    return label
  }()
  let gameGenre: UILabel = {
    let label = UILabel()
    label.font = UIFont.systemFont(ofSize: 13, weight: .light)
    label.textAlignment = .left
    label.numberOfLines = 0
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
    self.addSubview(gameImage)
    self.addSubview(gameMeta)
    self.addSubview(gameGenre)
    self.addSubview(gameMetaScore)
    self.addSubview(gameTitle)
    gameImage.snp.makeConstraints { (make) in
      make.top.left.equalTo(16)
      make.bottom.equalTo(-16)
      make.height.equalTo(104)
      make.width.equalTo(120)
    }
    gameTitle.snp.makeConstraints { make in
      make.top.equalTo(16)
      make.right.equalTo(-16)
      make.width.equalTo(207)
      make.left.equalTo(gameImage.snp.right).offset(16)
    }
    gameMeta.snp.makeConstraints { make in
      make.width.equalTo(76)
      make.left.equalTo(gameImage.snp.right).offset(16)
    }
    gameMetaScore.snp.makeConstraints { make in
      make.width.equalTo(26)
      make.left.equalTo(gameMeta.snp.right)
    }
    gameGenre.snp.makeConstraints { make in
      make.bottom.equalTo(-12)
      make.left.equalTo(gameImage.snp.right).offset(16)
      make.top.equalTo(gameMeta.snp.bottom).offset(8)
      make.top.equalTo(gameMetaScore.snp.bottom).offset(8)
      make.right.equalToSuperview().offset(-16)
    }
  }
}
struct GameItem: IdentifiableComponent {
  func referenceSize(in bounds: CGRect) -> CGSize? {
    return CGSize(width: bounds.size.width , height: 136)
  }
  
  func shouldContentUpdate(with next: GameItem) -> Bool {
    return true
  }
  
  var title: String
  var metaScore: String
  var genre: [Genre]
  var image: URL?
  var onSelect: () -> Void
  var id: String {
    title
  }

  func renderContent() -> GamesView {
    return GamesView()
  }

  func render(in content: GamesView) {
    content.gameTitle.text = title
    content.gameMeta.text = "metacritic:"
    content.gameMetaScore.text = metaScore
    content.gameGenre.text = genreToString(array: genre)
    content.gameImage.kf.setImage(with: image)
    content.onSelect = onSelect
  }
  func genreToString(array:[Genre]) -> String{
    let string = array.map { genre in
      "\(genre.name ?? "")"
    }
    return string.joined(separator: ", ")
  }
}

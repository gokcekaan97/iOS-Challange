//
//  GameItemComponent.swift
//  iOS-Challange
//
//  Created by kaan gokcek on 6.06.2023.
//

import Foundation
import Carbon
import Kingfisher

struct GameItem: IdentifiableComponent {
  func referenceSize(in bounds: CGRect) -> CGSize? {
    return CGSize(width: bounds.size.width , height: 136)
  }
  
  func shouldContentUpdate(with next: GameItem) -> Bool {
    return true
  }
  
  var title: String
  let downsampling = DownsamplingImageProcessor(size: CGSize(width: 120, height: 104))
  var metaScore: String?
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
    if metaScore != nil{
      content.gameMetaScore.text = metaScore
    }else {
      content.gameMetaScore.text = "NA"
    }
    content.gameGenre.text = genreToString(array: genre)
    content.gameImage.kf.setImage(with: image, options: [.processor(downsampling)])
    content.onSelect = onSelect
//    content.backgroundColor = .systemGray
  }
  func genreToString(array:[Genre]) -> String{
    let string = array.map { genre in
      "\(genre.name ?? "")"
    }
    return string.joined(separator: ", ")
  }
}

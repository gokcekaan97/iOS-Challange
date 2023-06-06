//
//  Game.swift
//  iOS-Challange
//
//  Created by kaan gokcek on 29.05.2023.
//

import Foundation
import RealmSwift

struct Games: Codable {
  let id: Int
  let name: String
  let genres: [Genre]
  let backgroundImage: String?
  let metacritic : Int?
    
  enum CodingKeys: String, CodingKey {
    case id
    case name
    case genres
    case backgroundImage = "background_image"
    case metacritic
  }
}

class GamesObject: Object {
  @Persisted var id: Int
  @Persisted var name: String
  @Persisted var didShown: Bool = false
  @Persisted var isFavourite: Bool = false
  @Persisted var genres: String
  @Persisted var backgroundImage: String?
  @Persisted var metacritic : Int?
}

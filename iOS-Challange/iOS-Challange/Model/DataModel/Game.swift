//
//  Game.swift
//  iOS-Challange
//
//  Created by kaan gokcek on 29.05.2023.
//

import Foundation

struct Game: Codable {
    let id: Int
    let name: String
  let genres: [Genre]
    let backgroundImage: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
      case genres
        case backgroundImage = "background_image"
    }
}

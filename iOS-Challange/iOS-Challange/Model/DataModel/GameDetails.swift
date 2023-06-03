//
//  GameDetails.swift
//  iOS-Challange
//
//  Created by kaan gokcek on 3.06.2023.
//

import Foundation

struct GameDetails: Codable {
  let id: Int
  let name: String
  let backgroundImage: String?
  let description : String
  let redditUrl: String
  let website: String?
    
  enum CodingKeys: String, CodingKey {
    case id
    case name
    case backgroundImage = "background_image"
    case description
    case redditUrl = "reddit_url"
    case website
  }
}

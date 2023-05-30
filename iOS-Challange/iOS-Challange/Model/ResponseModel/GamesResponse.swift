//
//  GamesResponse.swift
//  iOS-Challange
//
//  Created by kaan gokcek on 29.05.2023.
//

import Foundation

struct GamesResponse: Codable{
  let count: Int
  let next: String?
  let previous: String?
  let results: [Game]
}

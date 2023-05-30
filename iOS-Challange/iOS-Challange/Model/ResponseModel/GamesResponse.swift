//
//  GamesResponse.swift
//  iOS-Challange
//
//  Created by kaan gokcek on 29.05.2023.
//

import Foundation

struct GamesResponse: Codable{
  var count: Int
  var next: String?
  var previous: String?
  var results: [Game]
}

//
//  ApiService.swift
//  iOS-Challange
//
//  Created by kaan gokcek on 29.05.2023.
//

import Foundation
import Alamofire
import Combine


final class ApiService {
  static let shared = ApiService()
//  let realm = try! Realm()
  private init() {
    
  }
  enum ApiServiceError: Error {
    case noData
    case urlNil
    case decodeError
  }
  public func execute<T: Codable>(_ request: ApiRequest,
                                  expecting type: T.Type) -> AnyPublisher<T,AFError>{
    let url = request.url
    return AF.request(url!, method:.get)
      .validate()
      .publishDecodable(type: T.self)
      .value()
      .receive(on: DispatchQueue.main)
      .eraseToAnyPublisher()
  }
}
protocol GamesUseCaseType {
  func getGamesInfo() -> AnyPublisher<GamesResponse,AFError>
  
}
struct GamesUseCase : GamesUseCaseType {
  func getGamesInfo() -> AnyPublisher<GamesResponse,AFError>{
    let call = ApiService.shared.execute(.gamesApiRequest,
                              expecting: GamesResponse.self)
    return call
  }
}
enum ApiEndpoint: String {
  case games = "/games"
}


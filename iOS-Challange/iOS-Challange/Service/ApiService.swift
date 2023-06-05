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
    func getMoreGamesInfo(pageInt: Int) -> AnyPublisher<GamesResponse,AFError>
    func getSpecificGamesInfo(name:String, pageInt: Int) -> AnyPublisher<GamesResponse,AFError>
    func getGameDetail(gameId:Int) -> AnyPublisher<GameDetails,AFError>
    
  }
  struct GamesUseCase : GamesUseCaseType {
    func getGamesInfo() -> AnyPublisher<GamesResponse,AFError>{
      let call = ApiService.shared.execute(.gamesApiRequest,
                                           expecting: GamesResponse.self)
      return call
    }
    func getGameDetail(gameId:Int) -> AnyPublisher<GameDetails,AFError>{
      let detailRequest = ApiRequest(endpoint: .gameDetail, gameId: gameId)
      let call = ApiService.shared.execute(detailRequest,
                                           expecting: GameDetails.self)
      return call
    }
    func getMoreGamesInfo(pageInt: Int) -> AnyPublisher<GamesResponse,AFError>{
      let detailRequest = ApiRequest(endpoint: .games, queryParameters: [
        URLQueryItem(name: "page", value: "\(pageInt)")
      ])
      let call = ApiService.shared.execute(detailRequest,
                                           expecting: GamesResponse.self)
      return call
    }
    func getSpecificGamesInfo(name:String, pageInt: Int) -> AnyPublisher<GamesResponse,AFError>{
      var queryItems: [URLQueryItem] = []
      if pageInt != 0 {
        queryItems.append(URLQueryItem(name: "page", value: "\(pageInt)"))
        queryItems.append(URLQueryItem(name: "search", value: "\(name)"))
      }else{
        queryItems.append(URLQueryItem(name: "search", value: "\(name)"))
      }
      let detailRequest = ApiRequest(endpoint: .games, queryParameters: queryItems)
      let call = ApiService.shared.execute(detailRequest,
                                           expecting: GamesResponse.self)
      return call
    }
  }
  enum ApiEndpoint: String {
    case games = "/games"
    case gameDetail = "/games/"
  }

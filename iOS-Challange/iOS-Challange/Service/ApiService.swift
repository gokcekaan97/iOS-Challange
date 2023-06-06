//
//  ApiService.swift
//  iOS-Challange
//
//  Created by kaan gokcek on 29.05.2023.
//

import Foundation
import Alamofire
import Combine
import RealmSwift

final class ApiService {
  static let shared = ApiService()
  let realm = try! Realm()
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
  func favourite(game: GameDetails){
    let id = game.id
    let favoriteGame = GamesObject()
    favoriteGame.id = id
    favoriteGame.name = game.name
    favoriteGame.isFavourite = true
    favoriteGame.didShown = true
    favoriteGame.backgroundImage = game.backgroundImage
    favoriteGame.genres = genreToString(array: game.genres)
    favoriteGame.metacritic = game.metacritic
    let gameExist = realm.objects(GamesObject.self).where{
      $0.id == id
    }
    if gameExist.isEmpty {
      try! realm.write {
        realm.add(favoriteGame)
      }
    }else{
      try! realm.write{
        realm.delete(gameExist)
      }
    }
  }
  func favouritesExist() -> Bool {
    var bool = false
    let favoriteGame = realm.objects(GamesObject.self).first
    if favoriteGame == nil {
      bool = false
    }else{
      bool = true
    }
    return bool
  }
  func favourites() -> [GamesObject] {
    let favoriteGames = realm.objects(GamesObject.self).toArray() as [GamesObject]
    return favoriteGames
  }
  func favouriteCount() -> Int {
    let favoriteGames = realm.objects(GamesObject.self).toArray() as [GamesObject]
    return favoriteGames.count
  }

//  func shown(game: Games){
//    let id = game.id
//    let shownGame = GamesObject()
//    shownGame.id = id
//    shownGame.didShown = true
//    let gameExist = realm.objects(GamesObject.self).where{
//      $0.id == id
//    }
//    if gameExist.first?.didShown != true {
//      try! realm.write {
//        realm.add(shownGame)
//      }
//    }
//  }
//  func didShown(game: Games) -> Bool {
//    let id = game.id
//    var bool = false
//    let favoriteGame = realm.objects(GamesObject.self).where{
//      $0.id == id
//    }
//    if !favoriteGame.isEmpty{
//      bool = true
//    }
//    return bool
//  }
//  func unFavourite(game: Int) {
//    let id = game
//    let favouriteGame = realm.objects(GamesObject.self).where{
//      $0.id == id
//    }
//    if !favouriteGame.isEmpty{
//      try! realm.write{
//        favouriteGame.first?.setValue(false, forKey: "isFavourite")
//      }
//    }
//  }
  func genreToString(array:[Genre]) -> String{
    let string = array.map { genre in
      "\(genre.name ?? "")"
    }
    return string.joined(separator: ", ")
  }
}
  protocol GamesUseCaseType {
    func getGamesInfo() -> AnyPublisher<GamesResponse,AFError>
    func getMoreGamesInfo(pageInt: Int) -> AnyPublisher<GamesResponse,AFError>
    func getSpecificGamesInfo(name:String, pageInt: Int) -> AnyPublisher<GamesResponse,AFError>
    func getGameDetail(gameId:Int) -> AnyPublisher<GameDetails,AFError>
    func favourite(game:GameDetails)
//    func unFavourite(game:Int)
    func favouritesExist() -> Bool
    func favouriteCount() -> Int
    func favourites() -> [GamesObject]
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
      let detailRequest = ApiRequest(endpoint: .games,
                                     queryParameters: [URLQueryItem(name: "page",
                                                                    value: "\(pageInt)")])
      let call = ApiService.shared.execute(detailRequest,
                                           expecting: GamesResponse.self)
      return call
    }
    func getSpecificGamesInfo(name:String, pageInt: Int) -> AnyPublisher<GamesResponse,AFError>{
      var queryItems: [URLQueryItem] = []
      if pageInt != 0 {
        queryItems.append(URLQueryItem(name: "page",
                                       value: "\(pageInt)"))
        queryItems.append(URLQueryItem(name: "search",
                                       value: "\(name)"))
      }else{
        queryItems.append(URLQueryItem(name: "search",
                                       value: "\(name)"))
      }
      let detailRequest = ApiRequest(endpoint: .games,
                                     queryParameters: queryItems)
      let call = ApiService.shared.execute(detailRequest,
                                           expecting: GamesResponse.self)
      return call
    }
//    func unFavourite(game: Int){
//      ApiService.shared.unFavourite(game: game)
//    }
    func favourite(game: GameDetails) {
      ApiService.shared.favourite(game: game)
    }
    func favouritesExist() -> Bool{
      return ApiService.shared.favouritesExist()
    }
    func favourites() -> [GamesObject]{
      return ApiService.shared.favourites()
    }
    func favouriteCount() -> Int {
      return ApiService.shared.favouriteCount()
    }
  }
  enum ApiEndpoint: String {
    case games = "/games"
    case gameDetail = "/games/"
  }

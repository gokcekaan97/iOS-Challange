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
    let favoriteGame = GamesObject()
    favoriteGame.id = game.id
    favoriteGame.name = game.name
    favoriteGame.isFavourite = true
    favoriteGame.didShown = true
    favoriteGame.backgroundImage = game.backgroundImage
    favoriteGame.genres = genreToString(array: game.genres)
    favoriteGame.metacritic = game.metacritic
    let gameExist = realm.objects(GamesObject.self).where{
      $0.id == game.id
    }
    if !gameExist.isEmpty {
      if let favouritedGameBool = gameExist.first?.isFavourite, favouritedGameBool == false {
        try! realm.write {
          gameExist.first?.setValue(true, forKey: "isFavourite")
        }
      }else if let favouritedGameBool = gameExist.first?.isFavourite, favouritedGameBool == true{
        try! realm.write {
          gameExist.first?.setValue(false, forKey: "isFavourite")
        }
      }
    }
  }
  func favouritesExist(gameInt: Int) -> Bool {
    let id = gameInt
    var bool = false
    let favouriteGame = realm.objects(GamesObject.self).where {
      $0.id == id
    }
    if !favouriteGame.isEmpty {
      if let gameFavouriteBool = favouriteGame.first, gameFavouriteBool.isFavourite == false{
        bool = false
      }else if let gameFavouriteBool = favouriteGame.first, gameFavouriteBool.isFavourite == true{
        bool = true
      }
    }
    return bool
  }
  func unFavourite(game: Int) {
    let id = game
    let gameExist = realm.objects(GamesObject.self).where{
      $0.id == id
    }
    if let favouritedGameBool = gameExist.first?.isFavourite, favouritedGameBool == true{
      try! realm.write{
        gameExist.first?.setValue(false, forKey: "isFavourite")
      }
    }
  }
  func favourites() -> [GamesObject] {
    let favoriteGames = realm.objects(GamesObject.self).where{
      $0.isFavourite == true
    }.toArray() as [GamesObject]
    return favoriteGames
  }
  func favouriteCount() -> Int {
    let favoriteGames = realm.objects(GamesObject.self).where{
      $0.isFavourite == true
    }.toArray() as [GamesObject]
    return favoriteGames.count
  }

  func shown(game: GameDetails){
    let shownGame = GamesObject()
    shownGame.id = game.id
    shownGame.name = game.name
    shownGame.didShown = true
    shownGame.backgroundImage = game.backgroundImage
    shownGame.genres = genreToString(array: game.genres)
    shownGame.metacritic = game.metacritic
    let gameExist = realm.objects(GamesObject.self).where{
      $0.id == game.id
    }
    if gameExist.isEmpty {
      try! realm.write {
        realm.add(shownGame)
      }
    }
  }
  func didShown(game: Games) -> Bool {
    var bool = false
    let shownGames = realm.objects(GamesObject.self).where{
      $0.didShown == true
    }
    let shownGamesBool = shownGames.where {
      $0.id == game.id
    }.toArray() as [GamesObject]
    if shownGamesBool.isEmpty {
      bool = false
    }else{
      bool = true
    }
    return bool
  }
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
    func unFavourite(game:Int)
    func favouritesExist(gameInt: Int) -> Bool
    func shown(game: GameDetails)
    func didShown(game: Games) -> Bool
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
    func unFavourite(game: Int){
      ApiService.shared.unFavourite(game: game)
    }
    func favourite(game: GameDetails) {
      ApiService.shared.favourite(game: game)
    }
    func favouritesExist(gameInt: Int) -> Bool{
      return ApiService.shared.favouritesExist(gameInt: gameInt)
    }
    func favourites() -> [GamesObject]{
      return ApiService.shared.favourites()
    }
    func favouriteCount() -> Int {
      return ApiService.shared.favouriteCount()
    }
    func shown(game: GameDetails){
      ApiService.shared.shown(game: game)
    }
    func didShown(game: Games) -> Bool {
      return ApiService.shared.didShown(game: game)
    }
  }
  enum ApiEndpoint: String {
    case games = "/games"
    case gameDetail = "/games/"
  }

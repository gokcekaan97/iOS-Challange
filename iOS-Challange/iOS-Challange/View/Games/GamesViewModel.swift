//
//  GamesViewModel.swift
//  iOS-Challange
//
//  Created by kaan gokcek on 29.05.2023.
//

import Foundation

class GamesViewModel{
  var games = [Game]()
  var count: Int?
  let gamesUseCase = GamesUseCase()
  init(){
    getGames()
  }
  
  func getGames() {
    gamesUseCase.getGamesInfo { result in
      switch result {
      case .success(let games):
        self.games.append(contentsOf: games.results)
        self.count = games.count
        print(games.results)
      case .failure(let error):
        print(error)
      }
    }
  }
}
protocol GamesUseCaseType {
  func getGamesInfo (completion: @escaping (Result<GamesResponse,Error>) -> Void)
  
}
struct GamesUseCase : GamesUseCaseType {
  func getGamesInfo(completion: @escaping (Result<GamesResponse,Error>) -> Void ) {
    ApiService.shared.execute(.gamesApiRequest,
                              expecting: GamesResponse.self){ result in
      switch result{
      case .success(let games):
        completion(.success(games))
      case .failure(let error):
        completion(.failure(error))
      }
    }
  }
}

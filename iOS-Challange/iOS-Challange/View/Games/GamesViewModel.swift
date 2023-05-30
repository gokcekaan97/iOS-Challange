//
//  GamesViewModel.swift
//  iOS-Challange
//
//  Created by kaan gokcek on 29.05.2023.
//

import Foundation

class GamesViewModel{
  var games = [Game]()
  let gamesUseCase = GamesUseCase()
  init(){
    getGames()
  }
  
  func getGames() {
    gamesUseCase.getGames { result in
      switch result {
      case .success(let games):
        self.games.append(contentsOf: games.results)
        print(games.results)
      case .failure(let error):
        print(error)
      }
    }
  }
}
protocol GamesUseCaseType {
  func getGames (completion: @escaping (Result<GamesResponse,Error>) -> Void)
}
struct GamesUseCase : GamesUseCaseType {
  func getGames(completion: @escaping (Result<GamesResponse,Error>) -> Void ) {
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

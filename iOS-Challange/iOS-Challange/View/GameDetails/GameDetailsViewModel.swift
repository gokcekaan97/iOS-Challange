//
//  GameDetailViewModel.swift
//  iOS-Challange
//
//  Created by kaan gokcek on 3.06.2023.
//

import Foundation
import Combine

class GameDetailsViewModel: ObservableObject{
  var cancellable = Set<AnyCancellable>()
  @Published var shouldPush: Bool = false
  var gameDetails: GameDetails?
  var count: Int?
  let gamesUseCase = GamesUseCase()
  var descriptionLine = 4
  init(gameId:Int){
    getGame(gameId: gameId)
  }
  func getGame(gameId:Int) {
    gamesUseCase.getGameDetail(gameId: gameId).sink { completion in
      switch completion{
      case .failure(let error):
        print(error)
      case .finished:
        self.shouldPush = true
      }
    } receiveValue: { GameDetails in
      self.gameDetails = GameDetails
    }.store(in: &cancellable)
  }
  func favourite(){
    if let game = gameDetails{
      gamesUseCase.favourite(game: game)
    }
  }
  func favouritesExist(gameInt: Int) -> Bool{
    return gamesUseCase.favouritesExist(gameInt: gameInt)
  }
  func shownGame(){
    if let game = gameDetails{
      gamesUseCase.shown(game: game)
    }
  }
}

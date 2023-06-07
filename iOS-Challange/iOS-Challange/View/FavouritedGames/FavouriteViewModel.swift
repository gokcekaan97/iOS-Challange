//
//  FavouriteViewModel.swift
//  iOS-Challange
//
//  Created by kaan gokcek on 6.06.2023.
//

import Foundation
import Combine

class FavouriteViewModel{
  var favouritedCounter: Int
  let gamesUseCase = GamesUseCase()
  var cancellable = Set<AnyCancellable>()
  var favouritedGames: [GamesObject] = []
  init() {
    favouritedCounter = gamesUseCase.favouriteCount()
    favouritedGames = gamesUseCase.favourites()
  }
  func getGame(gameId:Int) {
    gamesUseCase.getGameDetail(gameId: gameId).sink { completion in
      switch completion{
      case .failure(let error):
        print(error)
      case .finished:
        ()
      }
    } receiveValue: { GameDetails in
      ()
    }.store(in: &cancellable)
  }
  func getFavouritedGames(){
    favouritedGames = gamesUseCase.favourites()
  }
  func getFavouritesCount(){
    favouritedCounter = gamesUseCase.favouriteCount()
  }
  func unFavourite(indexPath:Int){
    gamesUseCase.unFavourite(game: favouritedGames[indexPath].id)
  }
}

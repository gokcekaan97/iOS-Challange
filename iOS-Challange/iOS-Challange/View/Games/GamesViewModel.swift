//
//  GamesViewModel.swift
//  iOS-Challange
//
//  Created by kaan gokcek on 29.05.2023.
//

import Foundation
import Combine

class GamesViewModel: ObservableObject{
  var cancellable = Set<AnyCancellable>()
  @Published var shouldPush: Bool = false
  var gamesList = [Games]()
  var count: Int?
  let gamesUseCase = GamesUseCase()
  init(){
    getGames()
  }
  func getGames() {
    gamesUseCase.getGamesInfo().sink { completion in
      switch completion{
      case .failure(let error):
        print(error)
      case .finished:
        self.shouldPush = true
      }
    } receiveValue: { GamesResponse in
      self.gamesList.append(contentsOf: GamesResponse.results)
    }.store(in: &cancellable)
  }
}


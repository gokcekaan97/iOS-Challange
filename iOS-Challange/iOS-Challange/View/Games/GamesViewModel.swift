//
//  GamesViewModel.swift
//  iOS-Challange
//
//  Created by kaan gokcek on 29.05.2023.
//

import Foundation
import Carbon
import Combine

class GamesViewModel: ObservableObject{
  var cancellable = Set<AnyCancellable>()
  @Published var shouldPush: Bool = false
  var gamesList = [Game]()
  var count: Int?
  let gamesUseCase = GamesUseCase()
  var gameSection: Section?
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
      self.gameSection = self.makeGameSection()
    }.store(in: &cancellable)
  }
  func makeGameSection() -> Section {
    var section = Section(id: "Games")
    for item in gamesList{
      let cell = CellNode(GameItem(title: item.name))
      section.cells.append(cell)
    }
    return section
  }
}


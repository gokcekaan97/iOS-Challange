//
//  GamesViewModel.swift
//  iOS-Challange
//
//  Created by kaan gokcek on 29.05.2023.
//

import Foundation
import Carbon
import Combine
import Kingfisher

class GamesViewModel: ObservableObject{
  var cancellable = Set<AnyCancellable>()
  @Published var shouldPush: Bool = false
  var gamesList = [Game]()
  var count: Int?
  let gamesUseCase = GamesUseCase()
  var gameSection: Section?
  var gameImage: UIImage?
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
      guard let urlString = item.backgroundImage else {return Section(id:"")}
      let tempImageURL = URL(string: urlString)
      guard let metaScore = item.metacritic else {return Section(id: "")}
      let metaScoreString = String(describing: metaScore)
      let cell = CellNode(GameItem(title: item.name,
                                   metaScore: metaScoreString,
                                   genre: item.genres,
                                   image: tempImageURL))
      section.cells.append(cell)
    }
    return section
  }
}


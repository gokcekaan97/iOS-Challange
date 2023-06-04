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
  var nextpage: Int?
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
      let stringSplit = GamesResponse.next?.components(separatedBy: "=")
      guard let pageNumber = stringSplit?[2] else {return}
      self.nextpage = Int(pageNumber)
    }.store(in: &cancellable)
  }
  func getMoreGames(){
    self.shouldPush = false
    if let number = nextpage {
      gamesUseCase.getMoreGamesInfo(pageInt: number).sink { completion in
        switch completion{
        case .failure(let error):
          print(error)
        case .finished:
          self.shouldPush = true
        }
      } receiveValue: { GamesResponse in
        self.gamesList.append(contentsOf: GamesResponse.results)
        let stringSplit = GamesResponse.next?.components(separatedBy: "=")
        guard let pageNumber = stringSplit?[2] else {return}
        self.nextpage = Int(pageNumber)
      }.store(in: &cancellable)
    }
  }
}


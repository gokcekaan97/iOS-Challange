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
  @Published var shouldUpdate: Bool = false
  var gamesList = [Games]()
  var nextPage: Int?
  var count: Int?
  let gamesUseCase = GamesUseCase()
  var searchText: String?
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
      self.searchText = ""
      self.gamesList.append(contentsOf: GamesResponse.results)
      let stringSplit = GamesResponse.next?.components(separatedBy: "=")
      guard let pageNumber = stringSplit?[2] else {return}
      self.nextPage = Int(pageNumber)
    }.store(in: &cancellable)
  }
  func getMoreGames(){
    if let searchString = searchText,
       let searchTextCount = searchText?.count,
       searchTextCount > 3{
      getSearch(name: searchString)
    }else {
      if let number = nextPage, nextPage != 0 {
        self.shouldUpdate = false
        gamesUseCase.getMoreGamesInfo(pageInt: number).sink { completion in
          switch completion{
          case .failure(let error):
            print(error)
          case .finished:
            self.shouldUpdate = true
          }
        }
      receiveValue: { GamesResponse in
          self.gamesList.append(contentsOf: GamesResponse.results)
          let stringSplit = GamesResponse.next?.components(separatedBy: "=")
          guard let pageNumber = stringSplit?[2] else {return}
          self.nextPage = Int(pageNumber)
        }.store(in: &cancellable)
      }else {
        getGames()
      }
    }
  }
  func getSpecificGames(name:String){
    self.gamesList.removeAll()
    self.nextPage = 0
    searchText = name
  }
  func removeData(){
    self.gamesList.removeAll()
    self.nextPage = 0
    searchText = ""
    self.shouldUpdate = false
    self.shouldPush = false
  }
  func getSearch(name: String){
    self.shouldUpdate = false
    let searchText = name.replacingOccurrences(of: " ", with: "-")
    if let number = nextPage{
      gamesUseCase.getSpecificGamesInfo(name: searchText, pageInt: number).sink { completion in
        switch completion{
        case .failure(let error):
          print(error)
        case .finished:
          self.shouldUpdate = true
        }
      } receiveValue: { GamesResponse in
        self.gamesList.append(contentsOf: GamesResponse.results)
        let stringSplit = GamesResponse.next?.components(separatedBy: "=")
        guard let pageNumber = stringSplit?[2].first?.description else {return}
        self.nextPage = Int(pageNumber)
      }.store(in: &cancellable)
    }
  }
  func favourite(games:Games){
    gamesUseCase.favourite(game: games)
  }
  func unFavourite(games:Games){
    gamesUseCase.unFavourite(game: games)
  }
  func isFavourite(games:Games) -> Bool{
    return gamesUseCase.isFavourite(game: games)
  }
}


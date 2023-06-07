//
//  ViewController.swift
//  iOS-Challange
//
//  Created by kaan gokcek on 29.05.2023.
//

import UIKit
import Carbon
import SnapKit
import Combine

class GamesViewCoordinator {
  var router: UINavigationController!
  init(router: UINavigationController){
    self.router = router
  }
  public func pushCoordinator(animated: Bool,
                      completion: (() -> Void)?) {
    guard let builder = GamesViewBuilder().build() else { return }
      router.pushViewController(builder, animated: true)
  }
}

class GamesViewBuilder {
  func build() -> UIViewController? {
    let gameViewController = GamesViewController()
    gameViewController.viewModel = GamesViewModel()
    return gameViewController
  }
}

class GamesViewController: UIViewController {
  public var viewModel: GamesViewModel!
  private var cancellable = Set<AnyCancellable>()
  private var sections = Section(id: "")
  private var sectionArray: [Section] = []
  private var noSearch = Section(id: "no search")
  private let tableView = UITableView()
  private let searchController = UISearchController()
  var isChildViewControllerWillDisAppear: Bool?
  private let renderer = Renderer(
    adapter: GamesTableViewAdapter(),
    updater: UITableViewUpdater()
  )
  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
  }
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    if !isMovingToParent{
      setupCarbonTableView()
    }
  }

  func setupUI(){
    title = "Games"
    view.addSubview(tableView)
    tableView.sectionHeaderTopPadding = 0.0
    noSearch.cells.append(CellNode(noGameSearch(title:"")))
    tableView.snp.makeConstraints { make in
        make.edges.equalToSuperview()
    }
    setSearchBar()
    setCarbon()
    didReady()
    lastRowShown()
  }
  func setCarbon(){
    renderer.target = tableView
  }
  func didReady(){
    if searchController.isActive, let textCount = searchController.searchBar.text?.count, textCount > 3{
      didReadyLogic()
    }else if !searchController.isActive{
      didReadyLogic()
    }
  }
  func didReadyLogic(){
    viewModel.$shouldPush
      .sink { [weak self] shouldPush in
        if shouldPush {
          self?.setupCarbonTableView()
        }
      }.store(in: &cancellable)
  }
  func lastRowShown(){
    if searchController.isActive, let textCount = searchController.searchBar.text?.count, textCount > 3{
      lastRowShownLogic()
    }else if !searchController.isActive{
      lastRowShownLogic()
    }
  }
  func lastRowShownLogic(){
    renderer.adapter.$lastShown
      .sink { [weak self] lastShown in
        if lastShown{
          self?.callMoreData()
        }
    }.store(in: &cancellable)
  }
  func setupCarbonTableView(){
    sections = makeGameSection()
    if searchController.isActive, let count = searchController.searchBar.text?.count, count > 3 {
      sectionArray.append(sections)
    }else if !searchController.isActive{
      sectionArray.append(sections)
    }
    renderer.render(sectionArray)
  }
  func callMoreData(){
    viewModel.getMoreGames()
    viewModel.$shouldUpdate
      .sink{[weak self] shouldUpdate in
        if shouldUpdate {
          self?.setupCarbonTableView()
        }
    }.store(in: &cancellable)
  }
  func clearCarbonView(){
    sectionArray = []
    renderer.render(sectionArray)
    callMoreData()
  }
  func setSearchBar(){
    searchController.searchResultsUpdater = self
    searchController.searchBar.delegate = self
    searchController.obscuresBackgroundDuringPresentation = false
    navigationItem.searchController = searchController
    navigationItem.hidesSearchBarWhenScrolling = false
  }
  func makeGameSection() -> Section {
    if searchController.isActive, let count = searchController.searchBar.text?.count, count > 3 {
      sectionArray = []
      let activityIndicator = CellNode(ActivityComponent(title: "Activity Indicator"))
      var section = Section(id: "Games")
      for item in viewModel.gamesList{
        var gameImageURL = URL(string: "")
        do{
          gameImageURL = try item.backgroundImage?.asURL()
        }
        catch let error {
          print(error)
        }
        let cell = CellNode(GameItem(title: item.name,
                                     metaScore: item.metacritic?.formatted(),
                                     genre: genreToString(array: item.genres),
                                     image: gameImageURL,
                                     onSelect: {
          GameDetailsViewCoordinator(router: self.navigationController ?? UINavigationController(),
                                     gameId: item.id).pushCoordinator(animated: true, completion: nil)
        },
                                     shownBool: viewModel.didGameShown(game: item)))
        section.cells.append(cell)
      }
      section.cells.append(activityIndicator)
      return section
    }else if !searchController.isActive{
      sectionArray = []
      let activityIndicator = CellNode(ActivityComponent(title: "Activity Indicator"))
      var section = Section(id: "Games")
      for item in viewModel.gamesList{
        var gameImageURL = URL(string: "")
        do{
          gameImageURL = try item.backgroundImage?.asURL()
        }
        catch let error {
          print(error)
        }
        let cell = CellNode(GameItem(title: item.name,
                                     metaScore: item.metacritic?.formatted(),
                                     genre: genreToString(array: item.genres),
                                     image: gameImageURL,
                                     onSelect: {
          GameDetailsViewCoordinator(router: self.navigationController ?? UINavigationController(),
                                     gameId: item.id).pushCoordinator(animated: true, completion: nil)
        },
                                     shownBool: viewModel.didGameShown(game: item)))
        section.cells.append(cell)
      }
      section.cells.append(activityIndicator)
      return section
    }
    return noSearch
  }
  func noSearchRender(){
    sectionArray = []
    sectionArray.append(noSearch)
    renderer.render(sectionArray)
  }
}

extension GamesViewController: UISearchControllerDelegate, UISearchResultsUpdating, UISearchBarDelegate{
  func updateSearchResults(for searchController: UISearchController) {
    if let len = searchController.searchBar.text?.count, len > 3{
      if let text = searchController.searchBar.text{
        viewModel.getSpecificGames(name: text)
      }
      clearCarbonView()
    }
  }
  func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
    noSearchRender()
  }
  func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
    viewModel.removeData()
    clearCarbonView()
  }
  func genreToString(array:[Genre]) -> String{
    let string = array.map { genre in
      "\(genre.name ?? "")"
    }
    return string.joined(separator: ", ")
  }
}







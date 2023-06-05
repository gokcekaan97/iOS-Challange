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
  private let tableView = UITableView()
  private let searchController = UISearchController()
  private let renderer = Renderer(
    adapter: GamesTableViewAdapter(),
    updater: UITableViewUpdater()
  )
  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
  }
  func setupUI(){
    title = "Games"
    view.addSubview(tableView)
    tableView.sectionHeaderTopPadding = 0.0
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
    viewModel.$shouldPush
      .sink { [weak self] shouldPush in
        if shouldPush {
          self?.setupCarbonTableView()
        }
      }.store(in: &cancellable)
  }
  func lastRowShown(){
    renderer.adapter.$lastShown
      .sink { [weak self] lastShown in
        if lastShown {
          self?.callMoreData()
        }
    }.store(in: &cancellable)
  }
  func setupCarbonTableView(){
    sections = makeGameSection()
    sectionArray.append(sections)
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
                                   genre: item.genres,
                                   image: gameImageURL,
                                   onSelect: {
        GameDetailsViewCoordinator(router: self.navigationController ?? UINavigationController(),
                                   gameId: item.id).pushCoordinator(animated: true, completion: nil)
      }))
      section.cells.append(cell)
    }
    section.cells.append(activityIndicator)
    return section
  }
//  func clearSearch(){
//    viewModel.gamesList.removeAll()
//    viewModel.nextPage = 0
//    viewModel.getGames()
//    sectionArray = []
//    didReady()
//  }
}

extension GamesViewController: UISearchControllerDelegate, UISearchResultsUpdating, UISearchBarDelegate{
  func updateSearchResults(for searchController: UISearchController) {
    if let len = searchController.searchBar.text?.count, len > 3{
      if let text = searchController.searchBar.text{
        viewModel.getSpecificGames(name: text)
      }
      clearCarbonView()
    }else{
      viewModel.removeData()
//      no game has been searched view
    }
  }
  func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
    viewModel.removeData()
    clearCarbonView()
  }
}







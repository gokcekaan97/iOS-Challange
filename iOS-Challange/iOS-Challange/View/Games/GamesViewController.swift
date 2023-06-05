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
  var cancellable = Set<AnyCancellable>()
  var sections: Section?
  var sectionArray: [Section] = []
  var shouldRender = false {
    didSet{
      setupTableView()
    }
  }
  private let tableView = UITableView()
  private let renderer = Renderer(
    adapter: GamesTableViewAdapter(),
    updater: UITableViewUpdater()
  )
  override func viewDidLoad() {
    super.viewDidLoad()
    title = "Games"
    setSearchBar()
    view.addSubview(tableView)
    tableView.sectionHeaderTopPadding = 0.0
    tableView.snp.makeConstraints { make in
        make.edges.equalToSuperview()
    }
    renderer.target = tableView
    viewModel.$shouldPush
      .sink { [weak self] shouldPush in
        if shouldPush {
          self?.setupTableView()
          self?.reload()
        }
      }.store(in: &cancellable)
    renderer.adapter.$lastShown
      .sink { [weak self] lastShown in
        if lastShown {
          self?.callMoreData()
        }
    }.store(in: &cancellable)
  }
  func render() {
    renderer.render(sectionArray)
  }
  func setupTableView(){
    sections = makeGameSection()
    sectionArray.append(sections ?? Section(id:""))
  }
  func callMoreData(){
    viewModel.getMoreGames()
    viewModel.$shouldPush
      .sink{[weak self] shouldPush in
        if shouldPush {
          self?.reload()
        }
    }.store(in: &cancellable)
  }
  func reload(){
    setupTableView()
    render()
  }
  func toggleShouldRender(){
    shouldRender.toggle()
  }
  func setSearchBar(){
    let searchController = UISearchController()
    searchController.obscuresBackgroundDuringPresentation = false
    navigationItem.searchController = searchController
    navigationItem.hidesSearchBarWhenScrolling = false
  }
  func makeGameSection() -> Section {
    sectionArray = []
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
//    let activityIndicator = CellNode(ActivityComponent(title: "Activity Indicator", animating: true))
//    section.cells.append(activityIndicator)
    return section
  }
}







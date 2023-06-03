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
  private let tableView = UITableView()
  private let renderer = Renderer(
      adapter: UITableViewAdapter(),
      updater: UITableViewUpdater()
  )
  override func viewDidLoad() {
    super.viewDidLoad()
    title = "Games"
    renderer.target = tableView
    viewModel.$shouldPush
      .sink { [weak self] shouldPush in
          if shouldPush {
            self?.setupUI()
          }
      }.store(in: &cancellable)
  }
  func render(section: Section) {
    renderer.render(section)
  }

  private func setupUI() {
    view.addSubview(tableView)
    tableView.snp.makeConstraints { make in
        make.edges.equalToSuperview()
    }
    let gameSection = makeGameSection()
    render(section: gameSection)
  }
  func makeGameSection() -> Section {
    var section = Section(id: "Games")
    for item in viewModel.gamesList{
      guard let urlString = item.backgroundImage else {return Section(id: "")}
      let tempImageURL = URL(string: urlString)
      guard let metaScore = item.metacritic else {return Section(id: "")}
      let metaScoreString = String(describing: metaScore)
      let cell = CellNode(GameItem(title: item.name,
                                   metaScore: metaScoreString,
                                   genre: item.genres,
                                   image: tempImageURL,
                                   onSelect: {
        GameDetailsViewCoordinator(router: self.navigationController ?? UINavigationController(),
                                   gameId: item.id).pushCoordinator(animated: true, completion: nil)
      }))
      section.cells.append(cell)
    }
    let activityIndicator = CellNode(ActivityComponent(title: "", animating: true))
    section.cells.append(activityIndicator)
    return section
  }
}







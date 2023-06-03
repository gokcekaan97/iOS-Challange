//
//  GameDetailsViewController.swift
//  iOS-Challange
//
//  Created by kaan gokcek on 3.06.2023.
//

import UIKit
import Combine
import Carbon

class GameDetailsViewCoordinator {
  var router: UINavigationController!
  var gameDetailId: Int?
  init(router: UINavigationController,gameId:Int){
    self.gameDetailId = gameId
    self.router = router
  }
  public func pushCoordinator(animated: Bool,
                              completion: (() -> Void)?) {
    guard let gameDetailsId = gameDetailId else {return}
    guard let builder = GameDetailsViewBuilder().build(gameId: gameDetailsId) else { return }
      router.pushViewController(builder, animated: true)
  }
}

class GameDetailsViewBuilder {
  func build(gameId:Int) -> UIViewController? {
    let gameViewController = GameDetailsViewController()
    gameViewController.viewModel = GameDetailsViewModel(gameId: gameId)
    return gameViewController
  }
}
class GameDetailsViewController: UIViewController {
  var cancellable = Set<AnyCancellable>()
  private let tableView = UITableView()
  public var viewModel: GameDetailsViewModel!
  private let renderer = Renderer(
      adapter: UITableViewAdapter(),
      updater: UITableViewUpdater()
  )
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .systemBackground
    renderer.target = tableView
    viewModel.$shouldPush
      .sink { [weak self] shouldPush in
          if shouldPush {
            self?.setupUI()
          }
      }.store(in: &cancellable)
  }
  private func setupUI() {
    view.addSubview(tableView)
    tableView.snp.makeConstraints { make in
        make.edges.equalToSuperview()
    }
    let gameDetailSection = makeGameSection()
    render(section: gameDetailSection)
  }
  func render(section: Section) {
    renderer.render(section)
  }
  func makeGameSection() -> Section {
    var section = Section(id: "Games")
    guard let urlString = viewModel.gameDetails?.backgroundImage else {return Section(id: "")}
    guard let gameName = viewModel.gameDetails?.name else {return Section(id: "")}
    guard let gameDescription = viewModel.gameDetails?.description else {return Section(id: "")}
    let tempImageURL = URL(string: urlString)
    let cell = CellNode(GameDetail(title: gameName,
                                   description: gameDescription,
                                   image: tempImageURL))
    let redditCell = CellNode(GameDetailVisit(title: "reddit"))
    let websiteCell = CellNode(GameDetailVisit(title: "website"))
    section.cells.append(cell)
    section.cells.append(redditCell)
    section.cells.append(websiteCell)
    return section
  }
}

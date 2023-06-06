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
  public var gameFavourited = false
  private let renderer = Renderer(
      adapter: UITableViewAdapter(),
      updater: UITableViewUpdater()
  )
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.sectionHeaderTopPadding = 0.0
    self.navigationItem.largeTitleDisplayMode = .never
    view.backgroundColor = .systemBackground
    renderer.target = tableView
    viewModel.$shouldPush
      .sink { [weak self] shouldPush in
          if shouldPush {
            self?.setupUI()
          }
      }.store(in: &cancellable)
  }
  @objc func favoriteButtonTapped(){
    viewModel.favourite()
    if let gameId = viewModel.gameDetails?.id{
      gameFavourited = viewModel.favouritesExist(gameInt: gameId)
      if gameFavourited{
        self.navigationItem.rightBarButtonItem?.title = "Favourited"
      }else{
        self.navigationItem.rightBarButtonItem?.title = "Favourite"
      }
    }
  }
  private func setupUI() {
    view.addSubview(tableView)
    tableView.snp.makeConstraints { make in
        make.edges.equalToSuperview()
    }
    viewModel.shownGame()
    let gameDetailSection = makeGameSection()
    render(section: gameDetailSection)
    self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "",
                                                                  style: .plain,
                                                                  target: self,
                                                                  action: #selector(favoriteButtonTapped))
    if let gameId = viewModel.gameDetails?.id{
      gameFavourited = viewModel.favouritesExist(gameInt: gameId)
      if gameFavourited{
        self.navigationItem.rightBarButtonItem?.title = "Favourited"
      }else{
        self.navigationItem.rightBarButtonItem?.title = "Favourite"
      }
    }
  }
  func render(section: Section) {
    renderer.render(section)
  }
  func makeGameSection() -> Section {
    var section = Section(id: "Games")
    guard let urlString = viewModel.gameDetails?.backgroundImage else {return Section(id: "")}
    guard let gameName = viewModel.gameDetails?.name else {return Section(id: "")}
    guard let gameDescription = viewModel.gameDetails?.description else {return Section(id: "")}
    guard let redditUrl = viewModel.gameDetails?.redditUrl else {fatalError("")}
    guard let websiteUrl = viewModel.gameDetails?.website else {return Section(id: "")}
    let tempImageURL = URL(string: urlString)
    let cell = CellNode(GameDetail(title: gameName,
                                   description: gameDescription,
                                   image: tempImageURL))
    let redditCell = CellNode(GameDetailVisit(title: "reddit",onSelect: {
      guard let url = URL(string: redditUrl) else { return }
      UIApplication.shared.open(url)
    }))
    let websiteCell = CellNode(GameDetailVisit(title: "website",onSelect: {
      guard let url = URL(string: websiteUrl) else { return }
      UIApplication.shared.open(url)
    }))
    section.cells.append(cell)
    section.cells.append(redditCell)
    section.cells.append(websiteCell)
    return section
  }
}

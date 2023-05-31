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
    renderer.target = tableView
    viewModel.$shouldPush
      .sink { [weak self] shouldPush in
          if shouldPush {
            self?.setupUI()
            print("asd")
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
    guard let gameSection = viewModel.gameSection else {return}
    render(section: gameSection)
  }
}







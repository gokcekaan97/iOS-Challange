//
//  FavouriteViewController.swift
//  iOS-Challange
//
//  Created by kaan gokcek on 6.06.2023.
//

import UIKit
import Carbon
import SnapKit
import Combine

class FavouriteViewBuilder {
  func build() -> UIViewController? {
    let favouriViewController = FavouriteViewController()
    let favouriteViewModel = FavouriteViewModel()
    favouriViewController.viewModel = favouriteViewModel
    return favouriViewController
  }
}
class FavouriteViewController: UIViewController {
  private let tableView = UITableView()
  public var viewModel: FavouriteViewModel!
  private var sectionArray: [Section] = []
  private var cancellable = Set<AnyCancellable>()
  var renderer = Renderer(
    adapter: FavouriteTableViewAdapter(),
    updater: UITableViewUpdater()
  )
  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
    swipeAction()
  }
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    renderSection()
  }
  private func setupUI() {
    self.tabBarController?.delegate = self
    title = "Favourites"
    tableView.sectionHeaderTopPadding = 0.0
    view.backgroundColor = .systemBackground
    renderer.target = tableView
    view.addSubview(tableView)
    tableView.snp.makeConstraints { make in
        make.edges.equalToSuperview()
    }
    renderSection()
  }
  func swipeAction(){
    renderer.adapter.$indexPath.sink { [weak self]indexPath in
      if indexPath > -1{
        self?.removeSwipe(indexPath: indexPath)
      }
    }.store(in: &cancellable)
  }
  func removeSwipe(indexPath:Int){
    viewModel.unFavourite(indexPath: indexPath)
    renderSection()
  }
  func makeNoFavouritedSection() -> Section {
    var section = Section(id: "Games")
    let cell = CellNode(noFavourite(title: ""))
    section.cells.append(cell)
    return section
  }
  func makeFavouritedSection() -> Section {
    var section = Section(id: "Games")
    for item in viewModel.favouritedGames{
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
    return section
  }
  func renderSection(){
    viewModel.getFavouritedGames()
    viewModel.getFavouritesCount()
    if viewModel.favouritedCounter == 0{
      sectionArray = []
      let noFavouritedSection = makeNoFavouritedSection()
      sectionArray.append(noFavouritedSection)
      renderer.render(sectionArray)
    }else{
      sectionArray = []
      let favouritedSection = makeFavouritedSection()
      sectionArray.append(favouritedSection)
      renderer.render(sectionArray)
    }
  }
}
extension FavouriteViewController: UITabBarControllerDelegate{
  func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
    if viewController.title == "Favourites"{
      renderSection()
    }
  }
}


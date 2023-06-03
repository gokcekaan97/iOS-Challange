//
//  GamesTabBar.swift
//  iOS-Challange
//
//  Created by kaan gokcek on 31.05.2023.
//

import UIKit

class GamesTabBar: UITabBarController {
  
  override func viewDidLoad() {
      super.viewDidLoad()
  }
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    // Create Tab one
    configureUIAppearance()
    guard let tabOne = GamesViewBuilder().build() else {return}
    let tabOneBarItem = UITabBarItem(
      title: "Games",
      image: UIImage(named: "Vector"),
      tag: 0
    )
    tabOne.tabBarItem = tabOneBarItem
    let gameView = UINavigationController(rootViewController: tabOne)
    // Create Tab two
    guard let tabTwo = GamesViewBuilder().build() else {return}
    let tabTwoBarItem2 = UITabBarItem(
      title: "Favorites",
      image: UIImage(named: "Icon"),
      tag: 1
    )
    tabTwo.tabBarItem = tabTwoBarItem2
    let favoriteView = UINavigationController(rootViewController: tabTwo)
    self.viewControllers = [gameView, favoriteView]
  }
  func configureUIAppearance() {
    let appearance = UINavigationBar.appearance()
    let titleTextAttributes: [NSAttributedString.Key: Any] = [
      .foregroundColor: UIColor.label
    ]
    appearance.tintColor = .label
    appearance.prefersLargeTitles = true
    appearance.isTranslucent = true
    appearance.titleTextAttributes = titleTextAttributes
    appearance.largeTitleTextAttributes = titleTextAttributes
  }
}

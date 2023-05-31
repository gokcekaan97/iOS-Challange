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
    self.viewControllers = [gameView, tabTwo]
  }
}

//
//  SplashViewController.swift
//  iOS-Challange
//
//  Created by kaan gokcek on 31.05.2023.
//

import UIKit

class SplashViewController: UIViewController {
  override func viewDidLoad() {
    super.viewDidLoad()
    self.present(GamesTabBar(), animated: true)
//    DispatchQueue.main.async {
//      self.isRequestCompleted()
//    }
  }
  func isRequestCompleted(){
    let myVC = GamesViewController()
    myVC.viewModel = GamesViewModel()
    myVC.viewModel.$shouldPush
      .sink { [weak self] shouldPush in
          if shouldPush {
            print("asd")
//              self?.pushToNextViewController()
          }
      }
  }
  func pushToNextViewController(){
    self.present(GamesTabBar(), animated: true)
  }
}

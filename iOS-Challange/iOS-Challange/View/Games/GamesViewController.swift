//
//  ViewController.swift
//  iOS-Challange
//
//  Created by kaan gokcek on 29.05.2023.
//

import UIKit
import Carbon
import SnapKit

class GamesViewController: UIViewController {
  let viewModel = GamesViewModel()
  @IBOutlet var tableView: UITableView!

  let renderer = Renderer(
      adapter: UITableViewAdapter(),
      updater: UITableViewUpdater()
  )

  override func viewDidLoad() {
    super.viewDidLoad()
    title = "Games"
    view.backgroundColor = .systemBackground
    renderer.target = tableView
  }
}

extension GamesViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    guard let count = viewModel.count else {return 0}
    return count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    var cell = UITableViewCell()
    cell.textLabel?.text = "asd"
    return cell
  }
  
  
}


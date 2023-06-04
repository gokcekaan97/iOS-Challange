//
//  GamesTableViewAdapter.swift
//  iOS-Challange
//
//  Created by kaan gokcek on 4.06.2023.
//

import Foundation
import Carbon
import Combine

class GamesTableViewAdapter: UITableViewAdapter {
  @Published var lastShown: Bool
  init() {
    self.lastShown = false
  }
  override func tableView(_ tableView: UITableView,
                          willDisplay cell: UITableViewCell,
                          forRowAt indexPath: IndexPath) {
    if indexPath.row ==  tableView.numberOfRows(inSection: 0) - 2 {
      if !lastShown{
        lastShown = true
      }
    }
  }
}

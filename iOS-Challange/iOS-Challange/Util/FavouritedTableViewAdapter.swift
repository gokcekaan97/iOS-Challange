//
//  FavouritedTableViewAdapter.swift
//  iOS-Challange
//
//  Created by kaan gokcek on 7.06.2023.
//

import Foundation
import Carbon
import UIKit

class FavouriteTableViewAdapter: UITableViewAdapter {
  @Published var indexPath: Int
  init() {
    self.indexPath = -1
  }
  func tableView(_ tableView: UITableView,
                 commit editingStyle: UITableViewCell.EditingStyle,
                 forRowAt indexPath: IndexPath) {
    if editingStyle == .delete {
      self.indexPath = indexPath.row
    }
  }
}

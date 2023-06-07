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
      showPopup { action in
        if action {
          self.indexPath = indexPath.row
        }
      }
    }
  }
  func showPopup(completion: @escaping (Bool) -> Void) {
    let alertController = UIAlertController(title: "Uyarı", message: "Silme işlemini gerçekleştirmek istiyor musunuz?", preferredStyle: .alert)
    alertController.addAction(UIAlertAction(title: "Evet",
                                            style: .default,
                                            handler: { _ in
      completion(true)
    }))
    alertController.addAction(UIAlertAction(title: "Hayır",
                                            style: .default,
                                            handler: { _ in
      completion(false)
    }))
    if let currentViewController = UIApplication.shared.keyWindow?.rootViewController {
      currentViewController.present(alertController,
                                    animated: true,
                                    completion: nil)
        }
  }
}

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
  private let tableView = UITableView()
      private let renderer = Renderer(
          adapter: UITableViewAdapter(),
          updater: UITableViewUpdater()
      )
  override func viewDidLoad() {
          super.viewDidLoad()
          title = "Hello"
    tableView.alwaysBounceVertical = false
          renderer.target = tableView
          setupUI()
          render()
      }
  
      func render() {
          var nodes: [CellNode] = []
        let cell1 = CellNode(HomeItem(title: "sdf"))
        let cell2 = CellNode(HomeItem(title: "asdf"))
        let spacer = CellNode(id: "spacer",SpacerComponent(10))
        nodes.append(cell1)
//        nodes.append(spacer)
        nodes.append(cell2)
          let section = Section(id: "ufuk", cells: nodes)
          
          renderer.render(section)
      }
  private func setupUI() {
          // TableView ve diğer arayüz bileşenlerini burada yapılandırabilirsiniz.
          view.addSubview(tableView) // TableView'ı ekranın görünür kısmına ekleyin
          tableView.snp.makeConstraints { make in
              make.edges.equalToSuperview()
          }
      }

}


struct HomeItem: IdentifiableComponent {
  func referenceSize(in bounds: CGRect) -> CGSize? {
    return CGSize(width: bounds.width, height: 100)
  }
  
  func shouldContentUpdate(with next: HomeItem) -> Bool {
    return true
  }
  
    var title: String
    var id: String {
        title
    }

    func renderContent() -> GameView {
      return GameView()
    }

    func render(in content: GameView) {
      content.lblTitle.text = title
    }
}
class GameView: UIView {
  let lblTitle: UILabel = {
      let v = UILabel()
      v.backgroundColor = .systemGreen
      v.textColor = .white
      v.textAlignment = .center
      v.layer.cornerRadius = 5
      v.layer.masksToBounds = true
      return v
  }()

    

  override init(frame: CGRect) {
    super.init(frame: frame)
    self.setupUI()
    }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
    func setupUI() {
      self.addSubview(lblTitle)
      lblTitle.snp.makeConstraints { (make) in
          make.top.left.equalTo(2)
          make.right.bottom.equalTo(-2)
      }
    }


}



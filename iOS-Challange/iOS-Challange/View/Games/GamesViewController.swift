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
//
//  let viewModel = GamesViewModel()
//  weak var tableView:UITableView?
//  let renderer = Renderer(
//      adapter: UITableViewAdapter(),
//      updater: UITableViewUpdater()
//  )
//
//  override func viewDidLoad() {
//    super.viewDidLoad()
//    title = "Games"
//    view.backgroundColor = .systemBackground
//    setupUI()
//    render()
//  }
//  func render() {
//    renderer.target = tableView
//    var sections: [Section] = []
//    let helloCell = CellNode(id: "hello", GamesView("ufuk"))
//    let helloSection = Section(id: "hello", cells: [helloCell])
//    sections.append(helloSection)
//    renderer.render(sections)
//
//  }
//  private func setupUI() {
//    view.addSubview(tableView ?? UITableView()) // TableView'ı ekranın görünür kısmına ekleyin
//    tableView?.snp.makeConstraints { make in
//        make.edges.equalToSuperview()
//    }
//
//  }
  


      private let tableView = UITableView()
      private let renderer = Renderer(
          adapter: UITableViewAdapter(),
          updater: UITableViewUpdater()
      )
  override func viewDidLoad() {
          super.viewDidLoad()
          title = "Hello"
          tableView.contentInset.top = 44
          renderer.target = tableView
          setupUI()
          render()
      }
      func render() {
          var sections: [Section] = []
          // Create a cell item containing the HelloMessage view
        let cell1 = CellNode(HomeItem(title: "sdf"))
//        let cell2 = CellNode()

//        let cell3 = CellNode(id: "hello", HelloMessage(id: 2, name: "cihad"))
//        let cell4 = CellNode(id: "hello", HelloMessage(id: 3, name: "selim"))
          // Create a section and assign the cell item to it
          let section1 = Section(id: "ufuk", cells: [cell1])
//        let section2 = Section(id: "hello", cells: [cell2])
//        let section3 = Section(id: "hello", cells: [cell3])
//        let section4 = Section(id: "hello", cells: [cell4])
          sections.append(section1)
//        sections.append(section2)
//        sections.append(section4)
//        sections.append(section3)
          renderer.render(sections)
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
    return bounds.size
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
      content.items.append(contentsOf: (1...20).map { index in "Item \(index)"})

    }
}
class GameView: UIView, UITableViewDelegate, UITableViewDataSource {
    lazy var tbl: UITableView = {
        let v = UITableView()
        v.rowHeight = 100
        v.separatorStyle = .none
        return v
    }()

    var items: [String] = []

  override init(frame: CGRect) {
    super.init(frame: frame)
    self.tbl = tbl
    self.setupUI()
    }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
    func setupUI() {
      tbl.delegate = self
      tbl.dataSource = self
      tbl.register(CustomCell.self, forCellReuseIdentifier: CustomCell.cellId)
      self.addSubview(tbl)
        tbl.snp.makeConstraints { (make) in
            make.edges.equalTo(self.safeAreaLayoutGuide)
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CustomCell.cellId, for: indexPath) as! CustomCell
        cell.lblTitle.text = items[indexPath.row]
        return cell
    }
}

class CustomCell: UITableViewCell {
    static var cellId = "cell"

    let lblTitle: UILabel = {
        let v = UILabel()
        v.backgroundColor = .systemGreen
        v.textColor = .white
        v.textAlignment = .center
        v.layer.cornerRadius = 5
        v.layer.masksToBounds = true
        return v
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupUI() {
        self.addSubview(lblTitle)
        lblTitle.snp.makeConstraints { (make) in
            make.top.left.equalTo(20)
            make.right.bottom.equalTo(-20)
        }
    }
}

//
//  GamesTableViewCell.swift
//  iOS-Challange
//
//  Created by kaan gokcek on 30.05.2023.
//

import Foundation
import UIKit
import Carbon
import SnapKit


class GamesView: UIView, Component {
    private let label = UILabel()
    init(_ name: String) {
        super.init(frame: .zero)
        setupUI()
        configure(with: name)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setupUI() {
        addSubview(label)
        label.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview() // Ekranın ortasında hizalama
        }
    }
    private func configure(with name: String) {
        label.text = "Hellooo, \(name)!"
        label.textColor = .black
    }
    func render(in content: GamesView) {
        // Burada herhangi bir işlem yapmanıza gerek yok
    }
    func referenceSize(in bounds: CGRect) -> CGSize? {
        return bounds.size // Etiketin boyutunu belirtmek için ekran boyutunu kullanıyoruz
    }
    func renderContent() -> GamesView {
        return self
    }
}

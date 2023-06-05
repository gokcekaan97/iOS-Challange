//
//  ActivityIndicatorView.swift
//  iOS-Challange
//
//  Created by kaan gokcek on 3.06.2023.
//

import Foundation
import UIKit
import SnapKit
import Carbon

class ActivityIndicatorView: UIView {
  let activityIndicator = UIActivityIndicatorView()
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.setupUI()
    }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func setupUI() {
    self.translatesAutoresizingMaskIntoConstraints = false
    self.addSubview(activityIndicator)
    activityIndicator.isHidden = false
    activityIndicator.snp.makeConstraints { (make) in
      make.centerX.equalTo(self)
      make.top.equalToSuperview().offset(10)
    }
  }
}
struct ActivityComponent: IdentifiableComponent {
  var title: String
  var id: String {
    title
  }
  
  func referenceSize(in bounds: CGRect) -> CGSize? {
    return CGSize(width: bounds.width, height: 60)
  }
  
  func shouldContentUpdate(with next: ActivityComponent) -> Bool {
    return true
  }

  func renderContent() -> ActivityIndicatorView {
    return ActivityIndicatorView()
  }

  func render(in content: ActivityIndicatorView) {
      content.activityIndicator.isHidden = false
      content.activityIndicator.startAnimating()
  }
}

//
//  ResultsExtension.swift
//  iOS-Challange
//
//  Created by kaan gokcek on 6.06.2023.
//

import Foundation
import RealmSwift

extension RealmCollection{
  func toArray<T>() ->[T]{
    return self.compactMap{$0 as? T}
  }
}

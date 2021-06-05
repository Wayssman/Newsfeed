//
//  LabelExtension.swift
//  Newsfeed
//
//  Created by Желанов Александр Валентинович on 05.06.2021.
//
import UIKit

extension UILabel {
  func configure(with font: UIFont) {
    self.font = font
    self.textAlignment = .justified
    self.numberOfLines = 0
  }
}

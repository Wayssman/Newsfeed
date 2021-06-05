//
//  GalleryCell.swift
//  NewsFeed
//
//  Created by Желанов Александр Валентинович on 25.04.2021.
//

import UIKit

final class GalleryCell: UICollectionViewCell {
  // MARK: - IBOutlets
  @IBOutlet weak var imageView: UIImageView!
  
  // MARK: - Public Methods
  override func prepareForReuse() {
    imageView?.image = nil
  }
  
  func configurateCell(with data: NewsMultimediaRealm) {
    backgroundColor = .black
    imageView.contentMode = .scaleAspectFit
    imageView.imageFromServerURL(data.url, placeHolder: nil)
  }
}

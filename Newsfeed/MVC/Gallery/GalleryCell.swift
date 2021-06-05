//
//  GalleryCell.swift
//  NewsFeed
//
//  Created by Желанов Александр Валентинович on 25.04.2021.
//

import UIKit

class GalleryCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    func config(data: NewsMultimediaRealm) {
        backgroundColor = .black
        imageView.contentMode = .scaleAspectFit
        imageView.imageFromServerURL(data.url, placeHolder: nil)
    }
}

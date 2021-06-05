//
//  NewsCell.swift
//  NewsFeed
//
//  Created by Желанов Александр Валентинович on 23.04.2021.
//

import UIKit

final class NewsfeedCell: UITableViewCell {
  // MARK: - IBOutlets
  @IBOutlet private weak var newsTitle: UILabel!
  @IBOutlet private weak var newsPreview: UIImageView!
  
  // MARK: - Public Properties
  override func prepareForReuse() {
    newsTitle?.text = ""
    newsPreview?.image = nil
  }
  
  func configurateCell(data: NewsResultRealm) {
    newsTitle?.text = data.title
    newsTitle?.lineBreakMode = .byTruncatingTail
    newsTitle?.font = UIFont.boldSystemFont(ofSize: 16)
    newsTitle?.numberOfLines = 0
    
    newsPreview.layer.cornerRadius = newsPreview.frame.width / 5
    newsPreview.contentMode = .scaleAspectFill
    if data.multimedia.count > 0 {
      // Берем предпоследнее изображение (с самым низким разрешением) для быстрой загруки
      newsPreview?.imageFromServerURL(data.multimedia[data.multimedia.count-1].url, placeHolder: nil)
    }
  }
}

//
//  DetailViewController.swift
//  NewsFeed
//
//  Created by Желанов Александр Валентинович on 23.04.2021.
//

import UIKit

final class DetailViewController: UIViewController {
  // MARK: - IBOutlets
  @IBOutlet private weak var contentView: UIView!
  @IBOutlet private weak var titleLabel: UILabel!
  @IBOutlet private weak var captionLabel: UILabel!
  @IBOutlet private weak var abstractLabel: UILabel!
  @IBOutlet private weak var imageView: UIImageView!
  @IBOutlet private weak var imageHeight: NSLayoutConstraint!
  
  // MARK: - Private Properties
  var data: NewsResultRealm?
  private var ratio: CGFloat = 0.0
  private var url: String?
  
  // MARK: - Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
    imageView.addGestureRecognizer(tapGestureRecognizer)
    
    NotificationCenter.default.addObserver(self, selector: #selector(rotated), name: UIDevice.orientationDidChangeNotification, object: nil)
  }
  
  override func viewWillAppear(_ animated: Bool) {
    // Задаю формат в коде - так удобнее
    titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
    titleLabel.textAlignment = .justified
    titleLabel.numberOfLines = 0
    
    captionLabel.font = UIFont.systemFont(ofSize: 14)
    captionLabel.textAlignment = .justified
    captionLabel.numberOfLines = 0
    captionLabel.textColor = .gray
    
    abstractLabel.font = UIFont.systemFont(ofSize: 16)
    abstractLabel.textAlignment = .justified
    abstractLabel.numberOfLines = 0
    
    titleLabel.text = data?.title
    abstractLabel.text = data?.abstract
    
    imageView.layer.cornerRadius = imageView.frame.width / 18
    imageView.isUserInteractionEnabled = true
    
    imageHeight.constant = 0 // Чтобы после изменения размера не было дерганий картинки
    // До начала отображения картинки достаем все необходимые параметры
    if let multimedia = data?.multimedia {
      if multimedia.count > 0 {
        let image = multimedia[0]
        ratio = CGFloat(image.height) / CGFloat(image.width)
        
        imageView.imageFromServerURL(image.url, placeHolder: nil) // Начинаем загрузку
        imageView.isHidden = false
        
        captionLabel.isHidden = false
        captionLabel.text = image.caption
      } else {
        imageView.isHidden = true
        captionLabel.isHidden = true
      }
    }
  }
  
  override func viewDidAppear(_ animated: Bool) { // Иначе размер ImageView кривой
    imageHeight.constant = imageView.frame.width * ratio // Рассчитываем высоту
  }
  
  // MARK: - Public Methods
  func configureDetailViewController(data: NewsResultRealm) {
    self.data = data
  }
  
  // MARK: - Private Methods
  @objc func rotated() {
    imageHeight.constant = imageView.frame.width * ratio
  }
  
  @objc func imageTapped() {
    guard let data = self.data else { return }
    
    if data.multimedia.count > 0 {
      // Т.к. для каждой статьи только одна картинка, передаем в галлерею две одинаковых
      let galleryData = [data.multimedia[0], data.multimedia[0]]
      let storyboard = UIStoryboard(name: "Main", bundle: nil)
      let galleryVC = storyboard.instantiateViewController(identifier: "GalleryBoard")
      
      if let gallery = galleryVC as? GalleryViewController {
        gallery.data = galleryData
        navigationController?.pushViewController(gallery, animated: true)
      }
    }
  }
  
  // MARK: - Deinitializers
  deinit {
    NotificationCenter.default.removeObserver(self, name: UIDevice.orientationDidChangeNotification, object: nil)
  }
}

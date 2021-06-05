//
//  GalleryViewController.swift
//  NewsFeed
//
//  Created by Желанов Александр Валентинович on 23.04.2021.
//

import UIKit

final class GalleryViewController: UIViewController {
  // MARK: - IBOutlets
  @IBOutlet weak var collectionView: UICollectionView!
  
  // MARK: - Private Properties
  private var data: [NewsMultimediaRealm] = []
  private var savedTint: UIColor?
  
  // MARK: - Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = .black
    
    collectionView.dataSource = self
    collectionView.delegate = self
    
    navigationController?.navigationBar.isTranslucent = false
    savedTint = navigationController?.navigationBar.barTintColor
    navigationController?.navigationBar.barTintColor = .black
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    navigationController?.navigationBar.isTranslucent = false
    // Второй цвет - Default
    navigationController?.navigationBar.barTintColor = savedTint ?? UIColor(red: 0.969, green: 0.969, blue: 0.969, alpha: 1.0)
  }
  
  // MARK: - Public Methods
  func configureGalleryViewController(with data: [NewsMultimediaRealm]) {
    self.data = data
  }
  
  override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
    collectionView.collectionViewLayout.invalidateLayout()
  }
}

// MARK: - UICollectionViewDataSource
extension GalleryViewController: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return data.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GalleryCell", for: indexPath) as! GalleryCell
    cell.configurateCell(with: data[indexPath.item])
    
    return cell
  }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension GalleryViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
  }
}

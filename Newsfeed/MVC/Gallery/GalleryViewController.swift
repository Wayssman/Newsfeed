//
//  GalleryViewController.swift
//  NewsFeed
//
//  Created by Желанов Александр Валентинович on 23.04.2021.
//

import UIKit

class GalleryViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var data: [NewsMultimediaRealm] = []
    
    private var savedTint: UIColor?

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
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        collectionView.collectionViewLayout.invalidateLayout()
    }
}

extension GalleryViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GalleryCell", for: indexPath) as? GalleryCell {
            cell.config(data: data[indexPath.item])
            
            return cell
        } else {
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
}

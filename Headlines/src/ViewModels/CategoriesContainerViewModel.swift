//
//  CategoriesContainerViewModel.swift
//  Canillitapp
//
//  Created by Ezequiel Becerra on 24/06/2018.
//  Copyright © 2018 Ezequiel Becerra. All rights reserved.
//

import Foundation
import UIKit

import SDWebImage

protocol CategoriesContainerViewModelDelegate: class {
    func didSelectCategory(_ category: Category)
}

class CategoriesContainerViewModel: NSObject {
    weak var delegate: CategoriesContainerViewModelDelegate?
    weak var collectionView: UICollectionView?
    
    var categories: [Category]?
    let categoriesService = CategoriesService()
    
    private func updateCategoryList() {
        let success: ([Category]?) -> Void = { [unowned self] categories in
            self.categories = categories
            self.collectionView?.reloadData()
        }
        
        let fail: (NSError) -> Void = { (error) in
            
        }
        
        categoriesService.categoriesList(success: success, fail: fail)
    }
    
    private func imageKeyFromCategory(_ category: Category) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "ddMMYYYY"
        let dateString = formatter.string(from: Date())
        let key = "\(category.identifier)_\(dateString)"
        return key
    }
    
    func blurredImageKey(from url: URL) -> String {
        return "\(url.absoluteString)_blur"
    }
    
    func loadImage(with category: Category, at cell: CategoryCollectionViewCell) {
        let key = imageKeyFromCategory(category)
        
        if SDWebImageManager.shared().imageCache.diskImageExists(withKey: key) {
            let cachedImage = SDWebImageManager.shared().imageCache.imageFromDiskCache(forKey: key)
            cell.backgroundImageView.image = cachedImage
        } else {
            guard let imageURL = category.imageURL else {
                return
            }
            
            cell.backgroundImageView.alpha = 0
            cell.backgroundImageView.sd_setImage(with: imageURL) {(image, _, _, _) in
                guard let img = image else {
                    return
                }
                
                DispatchQueue.global().async {
                    let tintColor = UIColor(white: 0, alpha: 0.35)
                    let blurredImage = img.applyBlurWithRadius(3, tintColor: tintColor, saturationDeltaFactor: 1)
                    
                    DispatchQueue.main.async {
                        cell.backgroundImageView.image = blurredImage
                        SDImageCache.shared().store(blurredImage, forKey: key, toDisk: true)
                        
                        UIView.animate(withDuration: 0.3, animations: {
                            cell.backgroundImageView.alpha = 1.0
                        })
                    }
                }
            }
        }
    }
    
    required init(delegate: CategoriesContainerViewModelDelegate?, collectionView: UICollectionView?) {
        super.init()
        self.delegate = delegate
        self.collectionView = collectionView
        updateCategoryList()
    }
}

// MARK: - UICollectionViewDataSource
extension CategoriesContainerViewModel: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let c = categories else {
            return 0
        }
        return c.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as?
            CategoryCollectionViewCell else {
                return collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        }

        guard let c = categories?[indexPath.row] else {
            return cell
        }
        
        cell.titleLabel.text = c.name
        loadImage(with: c, at: cell)
        
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension CategoriesContainerViewModel: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let d = delegate,
            let category = categories?[indexPath.row] else {
            return
        }
        
        d.didSelectCategory(category)
    }
}

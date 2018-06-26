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
    var categories: [Category]?
    
    private func mockedCategories() -> [Category] {
        var retVal: [Category] = [Category]()
        retVal.append(Category(identifier: "1", name: "Política", imageURL: URL(string: "https://images.clarin.com/2016/12/14/SygIZseNx_600x338.jpg")))
        retVal.append(Category(identifier: "2", name: "Internacionales", imageURL: URL(string: "https://images.clarin.com/2018/06/25/r1QBLykM7_600x338__1.jpg")))
        retVal.append(Category(identifier: "3", name: "Tecnología", imageURL: URL(string: "https://images.clarin.com/2018/06/25/rk-DTkkzX_600x338__1.jpg")))
        retVal.append(Category(identifier: "4", name: "Espectáculos", imageURL: URL(string: "https://bucket3.glanacion.com/anexos/fotos/39/2714339.jpg")))
        return retVal
    }
    
    func blurredImageKey(from url: URL) -> String {
        return "\(url.absoluteString)_blur"
    }
    
    func loadImage(with imageURL: URL, at cell: CategoryCollectionViewCell) {
        let key = blurredImageKey(from: imageURL)
        
        if SDWebImageManager.shared().imageCache.diskImageExists(withKey: key) {
            let cachedImage = SDWebImageManager.shared().imageCache.imageFromDiskCache(forKey: key)
            cell.backgroundImageView.image = cachedImage
        } else {
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
    
    required init(delegate: CategoriesContainerViewModelDelegate?) {
        super.init()
        self.delegate = delegate
        categories = mockedCategories()
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
        
        if let url = c.imageURL {
            loadImage(with: url, at: cell)
        }
        
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

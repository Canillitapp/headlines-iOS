//
//  ImageCacheManager.swift
//  Canillitapp
//
//  Created by Ezequiel Becerra on 13/11/2018.
//  Copyright © 2018 Ezequiel Becerra. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher

class ImageCacheManager {

    static let shared = ImageCacheManager()
    private let cache = ImageCache(name: "canillitapp.cache")
    private var cachedImages = [String: UIImage]()
    

    func image(forKey key: String, completion: ((UIImage?) -> Void)? = nil) {

        // Look for it on cache
        if let cachedImage = cachedImages[key] {
            DispatchQueue.main.async {
                completion?(cachedImage)
            }
        }

        // Look for it on disk
        cache.retrieveImageInDiskCache(forKey: key) { [unowned self] result in
            switch result {
            case .success(let image):
                self.cachedImages[key] = image
                DispatchQueue.main.async {
                    completion?(image)
                }
            case .failure(_):
                completion?(nil)
            }
        }
    }

    func setImage(_ image: UIImage, forKey key: String) {
        cachedImages[key] = image
        cache.store(image, forKey: key)
    }
}

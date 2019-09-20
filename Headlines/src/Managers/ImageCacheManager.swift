//
//  ImageCacheManager.swift
//  Canillitapp
//
//  Created by Ezequiel Becerra on 13/11/2018.
//  Copyright © 2018 Ezequiel Becerra. All rights reserved.
//

import Foundation
import UIKit
import SDWebImage

class ImageCacheManager {

    static let shared = ImageCacheManager()

    var cachedImages = [String: UIImage]()

    func image(forKey key: String, completion: ((_ image: UIImage?) -> Void)?) {

        // Look for it on cache
        if let cachedImage = cachedImages[key] {
            completion?(cachedImage)
            return
        }

        SDWebImageManager.shared.imageCache.queryImage(forKey: key, options: [], context: nil) { [weak self] (image, _, _) in
            if let image = image {
                self?.cachedImages[key] = image
            }

            completion?(image)
        }
    }

    func setImage(_ image: UIImage, forKey key: String) {
        cachedImages[key] = image

        DispatchQueue.main.async {
            SDImageCache.shared.store(image, forKey: key, completion: nil)
        }
    }
}

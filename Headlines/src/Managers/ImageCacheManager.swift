//
//  ImageCacheManager.swift
//  Canillitapp
//
//  Created by Ezequiel Becerra on 13/11/2018.
//  Copyright © 2018 Ezequiel Becerra. All rights reserved.
//

import Foundation
import SDWebImage
import UIKit

class ImageCacheManager {

    static let shared = ImageCacheManager()

    var cachedImages = [String: UIImage]()

    func image(forKey key: String) -> UIImage? {

        // Look for it on cache
        if let cachedImage = cachedImages[key] {
            return cachedImage
        }

        // Look for it on disk
        if let cachedImage = SDWebImageManager.shared().imageCache?.imageFromDiskCache(forKey: key) {
            // Cache it on memory
            cachedImages[key] = cachedImage
            return cachedImage
        }

        return nil
    }

    func setImage(_ image: UIImage, forKey key: String) {
        cachedImages[key] = image

        DispatchQueue.main.async {
            SDImageCache.shared().store(image, forKey: key, toDisk: true)
        }
    }
}

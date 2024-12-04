//
//  CacheManager.swift
//  SniffMeet
//
//  Created by 윤지성 on 12/4/24.
//

import UIKit

final class CacheableImage {
    let lastModified: String
    let imageData: Data

    init(lastModified: String, imageData: Data) {
        self.lastModified = lastModified
        self.imageData = imageData
    }
}

protocol ImageCacheable {
    func saveMemoryCache(urlString: String, lastModified: String?, imageData: Data?)
    func image(urlString: String) -> CacheableImage?
}

final class ImageNSCacheManager: ImageCacheable {
    static let shared = ImageNSCacheManager()
    private let cache: NSCache<NSString, CacheableImage>
    
    private init(cache: NSCache<NSString, CacheableImage> = NSCache<NSString, CacheableImage>()) {
        self.cache = cache
        cache.totalCostLimit = 5 * 1024 * 1024 // 5MB
    }
    func saveMemoryCache(urlString: String, lastModified: String?, imageData: Data?) {
        guard let lastModified,
              let imageData else { return }
        let cacheableImage = CacheableImage(lastModified: lastModified, imageData: imageData)
        SNMLogger.info("miss")
        cache.setObject(cacheableImage, forKey: urlString as NSString)
    }
    
    func image(urlString: String) -> CacheableImage? {
        SNMLogger.info("hit")
        return cache.object(forKey: urlString as NSString)
    }
}

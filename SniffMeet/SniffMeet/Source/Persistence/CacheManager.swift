//
//  CacheManager.swift
//  SniffMeet
//
//  Created by 윤지성 on 12/4/24.
//

import Foundation

protocol ImageCacheable {
    func save(urlString: String, lastModified: String?, imageData: Data?)
    func image(urlString: String) -> CacheableImage?
}

final class ImageNSCacheManager {
    static let shared = ImageNSCacheManager()
    
    private let cache: NSCache<NSString, CacheableImage>
    private let fileManager: FileManageable
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    
    private var cacheDirectoryPath: URL {
        let cachesURL = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
        let diskCacheURL = cachesURL.appendingPathComponent("DownloadedCache")
        return diskCacheURL
    }

    private init(
        cache: NSCache<NSString, CacheableImage> = NSCache<NSString, CacheableImage>(),
        fileManager: FileManageable = SNMFileManager())
    {
        self.cache = cache
        self.fileManager = fileManager
        cache.totalCostLimit = 5 * 1024 * 1024 // 5MB
    }
    
    func saveMemoryCache(urlString: String, cacheableImage: CacheableImage) {
        cache.setObject(cacheableImage, forKey: urlString as NSString)
    }
    
    func saveDiskCache(urlString: String, cacheableImage: CacheableImage) {
        do {
            let data = try encoder.encode(cacheableImage)
            try fileManager.set(data: data, forKey: urlString)
        } catch {
            SNMLogger.error("CacheManager-saveDiskCache: \(error.localizedDescription) ")
        }
    }
    
    func imageFromMemoryCache(urlString: String) -> CacheableImage? {
        return cache.object(forKey: urlString as NSString)
    }
    
    func imageFromDiskCache(urlString: String) -> CacheableImage? {
        do {
            let data = try fileManager.fetch(forKey: urlString)
            guard let data else { return nil }
            return try? decoder.decode(CacheableImage.self, from: data)
        } catch {
            SNMLogger.error("CacheManager-imageFromDiskCache: \(error.localizedDescription) ")
        }
        return nil
    }
}

extension ImageNSCacheManager: ImageCacheable {
    func save(urlString: String, lastModified: String?, imageData: Data?) {
        guard let lastModified,
              let imageData else { return }
        let cacheableImage = CacheableImage(lastModified: lastModified, imageData: imageData)
        
        saveMemoryCache(urlString: urlString, cacheableImage: cacheableImage)
        saveDiskCache(urlString: urlString, cacheableImage: cacheableImage)
    }
    
    func image(urlString: String) -> CacheableImage? {
        if let image = imageFromMemoryCache(urlString: urlString) { // 메모리 캐시 hit
            SNMLogger.info("memory cache hit")
            return image
        }
        if let image = imageFromDiskCache(urlString: urlString) { // 디스크 캐시 hit
            SNMLogger.info("disk cache hit")
            saveMemoryCache(urlString: urlString, cacheableImage: image)
            return image
        }
        // 모두 miss
        return nil
    }
}

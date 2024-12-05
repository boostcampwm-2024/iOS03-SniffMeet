//
//  RequestProfileImageUseCase.swift
//  SniffMeet
//
//  Created by Kelly Chui on 11/24/24.
//

import Foundation

protocol RequestProfileImageUseCase {
    func execute(fileName: String) async throws -> Data?
}

struct RequestProfileImageUseCaseImpl: RequestProfileImageUseCase {
    private let remoteImageManager: any RemoteImageManagable
    private let cacheManager: any ImageCacheable

    init(
        remoteImageManager: any RemoteImageManagable,
        cacheManager: any ImageCacheable
    ) {
        self.remoteImageManager = remoteImageManager
        self.cacheManager = cacheManager
    }

    func execute(fileName: String) async throws -> Data? {
        if let cacheableImage = cacheManager.image(urlString: fileName) { // 캐시에 있을 때
            do {
                let remoteImage = try await remoteImageManager.download(
                    fileName: fileName,
                    lastModified: cacheableImage.lastModified
                )
                if !remoteImage.isModified { // 변경되지 않음
                    SNMLogger.log("not modified")
                    return cacheableImage.imageData
                } else {
                    cacheManager.saveMemoryCache(urlString: fileName,
                                                 lastModified: remoteImage.lastModified,
                                                 imageData: remoteImage.imageData)
                    return remoteImage.imageData!
                }
            } catch {
                SNMLogger.error("RequestProfileImageUseCaseImpl: \(error.localizedDescription)")
                return nil
            }
        } else { // 캐시에 없을 때
            do {
                let remoteImage = try await remoteImageManager.download(
                    fileName: fileName,
                    lastModified: ""
                )
                cacheManager.saveMemoryCache(urlString: fileName,
                                             lastModified: remoteImage.lastModified,
                                             imageData: remoteImage.imageData)
                return remoteImage.imageData
            } catch {
                SNMLogger.error("RequestProfileImageUseCaseImpl: \(error.localizedDescription)")
                return nil
            }
        }
    }
}

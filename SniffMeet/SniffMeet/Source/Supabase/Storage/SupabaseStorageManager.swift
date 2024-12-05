//
//  SupabaseStorageManager.swift
//  SniffMeet
//
//  Created by sole on 11/24/24.
//

import Foundation

struct RemoteImage {
    let isModified: Bool
    let imageData: Data?
    let lastModified: String?
}

protocol RemoteImageManagable {
    func upload(imageData: Data, fileName: String, mimeType: MimeType) async throws
//    func download(fileName: String) async throws -> Data
    func download(fileName: String, lastModified: String) async throws -> RemoteImage
}

struct SupabaseStorageManager: RemoteImageManagable {
    private let networkProvider: SNMNetworkProvider

    init(networkProvider: SNMNetworkProvider) {
        self.networkProvider = networkProvider
    }
    func upload(
        imageData: Data,
        fileName: String,
        mimeType: MimeType = .image
    ) async throws {
        if SessionManager.shared.isExpired {
            try await SupabaseAuthManager.shared.refreshSession()
        }
        guard let session = SessionManager.shared.session else {
            throw SupabaseError.sessionNotExist
        }
        let response = try await networkProvider.request(
            with: SupabaseStorageRequest.upload(
                accessToken: session.accessToken,
                image: imageData,
                fileName: fileName,
                mimeType: mimeType
            )
        )
    }
    func download(fileName: String, lastModified: String) async throws -> RemoteImage {
        let response: SNMNetworkResponse = try await networkProvider.request(
            with: SupabaseStorageRequest.download(fileName: fileName,
                                                       lastModified: lastModified)
        )
        let recentLastModified = response.header?["Last-Modified"] as? String
        let imageResponse = RemoteImage(isModified: response.statusCode != .notModified,
                                        imageData: response.data,
                                        lastModified: recentLastModified ?? "" )
        return imageResponse
    }

}

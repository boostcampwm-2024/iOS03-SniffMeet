//
//  SupabaseStorageManager.swift
//  SniffMeet
//
//  Created by sole on 11/24/24.
//

import Foundation

protocol RemoteImageManagable {
    func upload(imageData: Data, fileName: String, mimeType: MimeType) async throws
    func download(fileName: String) async throws -> Data
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
        _ = try await networkProvider.request(
            with: SupabaseStorageRequest.upload(
                accessToken: session.accessToken,
                image: imageData,
                fileName: fileName,
                mimeType: mimeType
            )
        )
    }
    func download(fileName: String) async throws -> Data {
        let response = try await networkProvider.request(
            with: SupabaseStorageRequest.download(fileName: fileName)
        )
        return response.data
    }
}

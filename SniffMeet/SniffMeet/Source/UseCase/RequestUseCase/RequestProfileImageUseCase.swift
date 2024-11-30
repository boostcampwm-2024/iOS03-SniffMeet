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

    init(
        remoteImageManager: any RemoteImageManagable
    ) {
        self.remoteImageManager = remoteImageManager
    }

    func execute(fileName: String) async throws -> Data? {
        let data = try await remoteImageManager.download(fileName: fileName)
        return data
    }
}

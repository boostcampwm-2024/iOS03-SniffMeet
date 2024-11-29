//
//  SaveProfileImageUseCase.swift
//  SniffMeet
//
//  Created by sole on 11/25/24.
//

import Foundation

protocol SaveProfileImageUseCase {
    /// fileName을 반환합니다.
    func execute(imageData: Data) async throws -> String
}

struct SaveProfileImageUseCaseImpl: SaveProfileImageUseCase {
    private let remoteImageManager: any RemoteImageManagable
    private let userDefaultsManager: any UserDefaultsManagable

    init(
        remoteImageManager: any RemoteImageManagable,
        userDefaultsManager: any UserDefaultsManagable
    ) {
        self.remoteImageManager = remoteImageManager
        self.userDefaultsManager = userDefaultsManager
    }

    func execute(imageData: Data) async throws -> String {
        let fileName: String = UUID().uuidString
        try await remoteImageManager.upload(
            imageData: imageData,
            fileName: fileName,
            mimeType: .image
        )
        try userDefaultsManager.set(
            value: fileName,
            forKey: Environment.UserDefaultsKey.profileImage
        )
        return fileName
    }
}

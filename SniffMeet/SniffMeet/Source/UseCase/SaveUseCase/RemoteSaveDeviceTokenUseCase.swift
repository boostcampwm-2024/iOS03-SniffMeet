//
//  RemoteSaveDeviceTokenUseCase.swift
//  SniffMeet
//
//  Created by sole on 11/27/24.
//

import Foundation

protocol RemoteSaveDeviceTokenUseCase {
    func execute() async throws
}

struct RemoteSaveDeviceTokenUseCaseImpl: RemoteSaveDeviceTokenUseCase {
    private let keychainManager: any KeychainManagable
    private let remoteDBManager: any RemoteDatabaseManager

    init(
        keychainManager: any KeychainManagable,
        remoteDBManager: any RemoteDatabaseManager
    ) {
        self.keychainManager = keychainManager
        self.remoteDBManager = remoteDBManager
    }

    func execute() async throws {
        let deviceToken = try keychainManager.get(forKey: Environment.KeychainKey.deviceToken
        )
        // TODO: DB 확인 필요
        try await remoteDBManager.insertData(into: "device_token", with: Data(deviceToken.utf8))
    }
}

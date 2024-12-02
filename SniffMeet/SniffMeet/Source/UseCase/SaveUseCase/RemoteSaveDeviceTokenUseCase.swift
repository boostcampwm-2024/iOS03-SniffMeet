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
    private let jsonEncoder: JSONEncoder
    private let keychainManager: any KeychainManagable
    private let remoteDBManager: any RemoteDatabaseManager

    init(
        jsonEncoder: JSONEncoder,
        keychainManager: any KeychainManagable,
        remoteDBManager: any RemoteDatabaseManager
    ) {
        self.jsonEncoder = jsonEncoder
        self.keychainManager = keychainManager
        self.remoteDBManager = remoteDBManager
    }

    func execute() async throws {
        let deviceToken = try keychainManager.get(forKey: Environment.KeychainKey.deviceToken)
        let deviceTokenDTO = SaveDeviceTokenDTO(deviceToken: deviceToken)
        let deviceTokenData = try jsonEncoder.encode(deviceTokenDTO)
        try await remoteDBManager.updateData(
            into: Environment.SupabaseTableName.userInfo,
            with: deviceTokenData
        )
    }
}

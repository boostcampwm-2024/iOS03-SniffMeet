//
//  RegisterDeviceTokenUseCase.swift
//  SniffMeet
//
//  Created by sole on 11/25/24.
//

import Foundation

protocol RegisterDeviceTokenUseCase {
    func execute(deviceToken: Data) throws
}

struct RegisterDeviceTokenUseCaseImpl: RegisterDeviceTokenUseCase {
    private let keychainManager: any KeychainManagable

    init(keychainManager: any KeychainManagable) {
        self.keychainManager = keychainManager
    }

    func execute(deviceToken: Data) throws {
        let deviceTokenString = deviceToken.reduce("") { $0 + String(format: "%02X", $1) }
        try keychainManager.set(
            value: deviceTokenString,
            forKey: Environment.KeychainKey.deviceToken
        )
    }
}

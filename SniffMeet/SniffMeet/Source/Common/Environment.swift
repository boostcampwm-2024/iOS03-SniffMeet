//
//  Environment.swift
//  SniffMeet
//
//  Created by sole on 11/25/24.
//

enum Environment {
    enum UserDefaultsKey {
        static let profileImage: String = "profileImage"
        static let dogInfo: String = "dogInfo"
        static let expiresAt: String = "expiresAt"
    }

    enum KeychainKey {
        static let accessToken: String = "accessToken"
        static let refreshToken: String = "refreshToken"
    }
}

//
//  SupabaseRefreshResponse.swift
//  SniffMeet
//
//  Created by Kelly Chui on 11/19/24.
//

import Foundation

struct SupabaseRefreshTokenResponse: Codable {
    var accessToken: String
    var refreshToken: String
    var expiresAt: Int
    var tokenType: String

    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case refreshToken = "refresh_token"
        case expiresAt = "expires_At"
        case tokenType = "token_type"
    }
}

struct SupabaseRefreshUserResponse: Codable {
    var id: String
    var userMetadata: SupabaseUserMetadata

    enum CodingKeys: String, CodingKey {
        case id
        case userMetadata = "user_metadata"
    }
}

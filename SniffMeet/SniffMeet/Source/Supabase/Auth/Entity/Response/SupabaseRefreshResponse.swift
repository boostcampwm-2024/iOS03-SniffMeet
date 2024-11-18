//
//  SupabaseRefreshResponse.swift
//  SniffMeet
//
//  Created by Kelly Chui on 11/19/24.
//

import Foundation

struct supabaseRefreshTokenResponse: Codable {
    var accessToken: String
    var refreshToken: String
    var expiresIn: Int
    var tokenType: String

    enum codingKeys: String, CodingKey {
        case accessToken = "access_token"
        case refreshToken = "refresh_token"
        case expiresIn = "expires_in"
        case tokenType = "token_type"
    }
}

struct supabaseRefreshUserResponse: Codable {
    var id: String
    var userMetadata: SupabaseUserMetadata

    enum CodingKeys: String, CodingKey {
        case id
        case userMetadata = "user_metadata"
    }
}

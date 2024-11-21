//
//  SupabaseSession.swift
//  SniffMeet
//
//  Created by Kelly Chui on 11/17/24.
//

import Foundation

struct SupabaseSessionResponse: Codable {
    var accessToken: String
    var tokenType: String
    var expiresIn: Int
    var expiresAt: Int
    var refreshToken: String
    var user: SupabaseUserResponse

    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case tokenType = "token_type"
        case expiresIn = "expires_in"
        case expiresAt = "expires_at"
        case refreshToken = "refresh_token"
        case user
    }
}

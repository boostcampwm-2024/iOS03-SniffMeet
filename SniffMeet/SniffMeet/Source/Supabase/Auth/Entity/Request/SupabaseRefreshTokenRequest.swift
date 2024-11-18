//
//  AuthBody.swift
//  SniffMeet
//
//  Created by Kelly Chui on 11/18/24.
//

import Foundation

struct SupabaseRefreshTokenRequest: Encodable {
    var refreshToken: String

    enum CodingKeys: String, CodingKey {
        case refreshToken = "refresh_token"
    }
}

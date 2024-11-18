//
//  SupabaseSession.swift
//  SniffMeet
//
//  Created by Kelly Chui on 11/19/24.
//

import Foundation

struct SupabaseSession {
    var accessToken: String
    var expiresAt: Int
    var refreshToken: String
    var user: SupabaseUser

    init(from response: SupabaseSessionResponse) {
        self.accessToken = response.accessToken
        self.expiresAt = response.expiresAt
        self.refreshToken = response.refreshToken
        self.user = SupabaseUser(from: response.user)
    }

    init(accessToken: String, expiresAt: Int, refreshToken: String, user: SupabaseUser) {
        self.accessToken = accessToken
        self.expiresAt = expiresAt
        self.refreshToken = refreshToken
        self.user = user
    }
}

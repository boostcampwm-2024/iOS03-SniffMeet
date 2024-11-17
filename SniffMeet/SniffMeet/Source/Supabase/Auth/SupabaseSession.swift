//
//  SupabaseSession.swift
//  SniffMeet
//
//  Created by Kelly Chui on 11/17/24.
//

import Foundation

struct SupabaseSession {
    var accessToken: String
    var tokenType: String
    var expiresIn: Int
    var expiresAt: Int
    var refreshToken: String
}

struct User {
    var id: UUID
    var aud: String
    var role: String
    var email: String?
    var phone: String?
    var lastSignInAt: Date?
    var appMetadata: [String: Any]
    var user_metadata: [String: Any]
    var identities: [Any]?
    var createdAt: Date
    var updatedAt: Date
    var isAnonymous: Bool
}

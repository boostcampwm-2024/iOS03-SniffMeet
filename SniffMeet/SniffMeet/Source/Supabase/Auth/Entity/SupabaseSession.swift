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
    var user: SupabaseUser?
}

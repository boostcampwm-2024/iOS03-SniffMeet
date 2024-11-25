//
//  SupabaseUserResponse.swift
//  SniffMeet
//
//  Created by Kelly Chui on 11/19/24.
//

import Foundation

struct SupabaseUserResponse: Codable {
    var id: UUID
    var role: String
    var userMetadata: SupabaseUserMetadata

    enum CodingKeys: String, CodingKey {
        case id, role
        case userMetadata = "user_metadata"
    }
}

struct SupabaseUserMetadata: Codable {
    // var name: String
    // var profileImageURL: String
}

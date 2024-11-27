//
//  SupabaseUser.swift
//  SniffMeet
//
//  Created by Kelly Chui on 11/19/24.
//

import Foundation

struct SupabaseUser: Encodable {
    var userID: UUID
    // var name: String
    // var profileImageURL: URL

    init(from response: SupabaseUserResponse) {
        self.userID = response.id
        // self.name = response.userMetadata.name
        // self.profileImageURL = response.userMetadata.profileImageURL
    }
}

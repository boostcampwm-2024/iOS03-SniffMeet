//
//  SupabaseUser.swift
//  SniffMeet
//
//  Created by Kelly Chui on 11/19/24.
//

import Foundation

struct SupabaseUser {
    var id: String
    // var name: String
    // var profileImageURL: URL

    init(from response: SupabaseUserResponse) {
        self.id = response.id
        // self.name = response.userMetadata.name
        // self.profileImageURL = response.userMetadata.profileImageURL
    }
}

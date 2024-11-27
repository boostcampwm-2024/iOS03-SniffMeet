//
//  SupabaseUser.swift
//  SniffMeet
//
//  Created by Kelly Chui on 11/19/24.
//

import Foundation

struct SupabaseUser: Encodable {
    var userID: UUID

    init(from response: SupabaseUserResponse) {
        self.userID = response.id
    }
}

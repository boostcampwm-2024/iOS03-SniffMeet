//
//  Mate.swift
//  SniffMeet
//
//  Created by Kelly Chui on 11/24/24.
//

import Foundation

struct Mate {
    var name: String
    var userID: UUID
    var keywords: [Keyword]
    var profileImageURLString: String?
}

extension Mate {
    static let example: Mate = Mate(
        name: "후추",
        userID: UUID(),
        keywords: [.shy],
        profileImageURLString: nil
    )
}

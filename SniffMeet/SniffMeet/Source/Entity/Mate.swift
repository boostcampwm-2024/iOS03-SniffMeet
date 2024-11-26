//
//  Mate.swift
//  SniffMeet
//
//  Created by Kelly Chui on 11/24/24.
//

import Foundation

struct Mate: Decodable {
    var name: String
    var userID: UUID
    var profileImageURLString: String
    var profileImageData: Data?

    enum CodingKeys: String, CodingKey {
        case name
        case userID = "user_id"
        case profileImageURLString = "profile_image_url_string"
    }
}

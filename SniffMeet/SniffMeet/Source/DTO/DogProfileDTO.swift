//
//  DogProfileDTO.swift
//  SniffMeet
//
//  Created by Kelly Chui on 11/27/24.
//

import Foundation

struct DogProfileDTO: Codable {
    let name: String
    let keywords: [Keyword]
    let profileImage: Data?
}

extension DogProfileDTO {
    static let example: DogProfileDTO = DogProfileDTO(name: "후추",
                                                        keywords: [.shy],
                                                        profileImage: nil)
}

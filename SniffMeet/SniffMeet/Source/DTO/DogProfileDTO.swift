//
//  DogProfileDTO.swift
//  SniffMeet
//
//  Created by Kelly Chui on 11/27/24.
//

import Foundation

struct DogProfileDTO: Codable {
    let id: UUID
    let name: String
    let keywords: [Keyword]
    var profileImage: Data?
}

extension DogProfileDTO {
    static var example: DogProfileDTO = DogProfileDTO(id: UUID(uuidString: "4a8c392f-24af-4fbf-9043-11b4dd4c131b") ?? .init(),
                                                      name: "두식",
                                                      keywords: [.energetic, .friendly],
                                                      profileImage: nil)
}

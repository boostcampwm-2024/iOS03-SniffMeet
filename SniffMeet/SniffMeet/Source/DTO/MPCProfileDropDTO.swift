//
//  MateRequest.swift
//  SniffMeet
//
//  Created by 배현진 on 11/20/24.
//

import Foundation

struct MPCProfileDropDTO: Codable {
    let token: Data?
    let profile: DogProfileDTO?
    let transitionMessage: String?
}

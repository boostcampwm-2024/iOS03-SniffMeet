//
//  MateRequest.swift
//  SniffMeet
//
//  Created by 배현진 on 11/20/24.
//

import Foundation

struct ReceiveData: Codable {
    let token: Data?
    let profile: DogProfileInfo?
}

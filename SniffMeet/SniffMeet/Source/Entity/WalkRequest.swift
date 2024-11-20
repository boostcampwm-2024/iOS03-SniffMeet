//
//  WalkRequest.swift
//  SniffMeet
//
//  Created by 윤지성 on 11/20/24.
//

struct WalkRequest: Codable {
    let user: Int
    let address: Address
    let message: String
}

struct Address: Codable {
    let longtitude: Double
    let latitude: Double
    let location: String
}

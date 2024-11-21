//
//  WalkRequest.swift
//  SniffMeet
//
//  Created by 윤지성 on 11/20/24.
//

struct WalkRequest: Codable {
    let dog: Dog
    let address: Address
    let message: String
}

struct Address: Codable {
    let longtitude: Double
    let latitude: Double
    let location: String
}

extension Address {
    static let example: Address = Address(longtitude: 12.0, latitude: 12.0, location: "서울 코드스쿼드")
}

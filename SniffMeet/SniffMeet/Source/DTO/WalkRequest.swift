//
//  WalkRequest.swift
//  SniffMeet
//
//  Created by 윤지성 on 12/2/24.
//
import Foundation

struct WalkRequestInsertDTO: Encodable {
    let id: UUID
    let createdAt: String
    let sender: UUID
    let receiver: UUID
    let message: String
    let latitude: Double
    let longitude: Double
    let state: WalkRequestState
    
    enum CodingKeys: String, CodingKey {
        case id
        case createdAt = "created_at"
        case sender, receiver, message, latitude, longitude, state
    }
}

enum WalkRequestState: String, Encodable {
    case pending
    case accepted
    case declined
}

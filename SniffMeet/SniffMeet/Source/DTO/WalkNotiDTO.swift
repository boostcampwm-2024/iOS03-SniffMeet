//
//  WalkNotiDTO.swift
//  SniffMeet
//
//  Created by Kelly Chui on 11/27/24.
//

import Foundation

struct WalkNotiDTO: Decodable {
    let id: UUID
    let createdAt: String
    let message: String
    let latitude: Double
    let longtitude: Double
    let senderId: UUID
    let senderName: String
    
    var createdAtDate: Date? {
        let dateFormatter = ISO8601DateFormatter()
        return dateFormatter.date(from: createdAt)
    }
    
    func toEntity() -> WalkNoti {
        WalkNoti(id: id,
                 createdAt: createdAtDate,
                 message: message,
                 latitude: latitude,
                 longtitude: longtitude,
                 senderId: senderId,
                 senderName: senderName)
    }
}

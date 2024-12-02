//
//  WalkNotiDTO.swift
//  SniffMeet
//
//  Created by Kelly Chui on 11/27/24.
//

import Foundation

struct WalkNotiDTO: Codable {
    let id: UUID
    let createdAt: String
    let message: String
    let latitude: Double
    let longtitude: Double
    let senderId: UUID
    let receiverId: UUID
    let senderName: String
    let category: WalkNotiCategory

    enum CodingKeys: String, CodingKey {
        case id
        case createdAt = "created_at"
        case message, latitude, longtitude
        case senderId = "sender"
        case receiverId = "receiver"
        case senderName = "name"
        case category
    }
    
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
                 senderName: senderName,
                 category: category.rawValue)
    }
}

enum WalkNotiCategory: String, Codable {
    case walkRequest
    case walkAccepted
    case walkDeclined
}

extension WalkNotiDTO {
    static func example(id: UUID) -> WalkNotiDTO {
        WalkNotiDTO(id: UUID(),
                                         createdAt: Date().convertDateToISO8601String(),
                                         message: "You have a new notification.",
                                         latitude: 37.7749,
                                         longtitude: -122.4194,
                                         senderId: id,
                                         receiverId: UUID(uuidString: "d832acee-1e80-4252-a315-34eab143e92f")!,
                                         senderName: "두두3ㅜ두두두두식",
                                         category: WalkNotiCategory.walkRequest)
    }
}


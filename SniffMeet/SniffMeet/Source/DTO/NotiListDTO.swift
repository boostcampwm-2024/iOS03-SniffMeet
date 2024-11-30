//
//  NotiListDTO.swift
//  SniffMeet
//
//  Created by 윤지성 on 11/30/24.
//
import Foundation

struct NotiListInsertDTO: Encodable {
    let id: UUID
    let notifications: [UUID] = []
    enum CodingKeys: String, CodingKey {
        case id, notifications
    }
}

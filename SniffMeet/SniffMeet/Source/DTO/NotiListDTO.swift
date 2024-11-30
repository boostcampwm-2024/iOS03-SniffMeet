//
//  NotiListDTO.swift
//  SniffMeet
//
//  Created by 윤지성 on 11/30/24.
//
import Foundation

/// 회원가입 할 때, 빈 배열로 insert할 때 사용하는 DTO
struct WalkNotiListInsertDTO: Encodable {
    let id: UUID
    let notifications: [UUID] = []
    enum CodingKeys: String, CodingKey {
        case id, notifications
    }
}

/// 노티 리스트를 요청할 때, body에 보내야하는 DTO
struct WalkNotiListRequestDTO: Encodable {
    let userId: UUID
    
    enum CodingKeys: String, CodingKey {
        case userId = "p_id"
    }
}

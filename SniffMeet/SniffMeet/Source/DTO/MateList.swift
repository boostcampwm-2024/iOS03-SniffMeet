//
//  MateList.swift
//  SniffMeet
//
//  Created by 윤지성 on 11/28/24.
//
import Foundation

/// MateList를 insert할 때 쓰이는 DTO입니다.
/// 처음 회원가입할 때는 메이트가 없으므로 빈 배열로 고정했습니다.
struct MateListInsertDTO: Encodable {
    let id: UUID
    let mates: [UserInfoDTO] = []
}

struct MateListDTO: Codable {
    let mates: [UserInfoDTO]
}

struct MateListRequestDTO: Encodable {
    let userId: UUID
    
    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
    }
}

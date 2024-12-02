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
    let mates: [UUID] = [UUID(uuidString: "34cd1739-49af-4a19-802b-5df26ee32d5c") ?? .init(),
                         UUID(uuidString: "d0b2d49c-bda9-49f7-9e95-86fe819c14a4") ?? .init(),
                         UUID(uuidString: "75a2085e-3f25-4b3b-8f8c-454d3bba198b") ?? .init(),
                         UUID(uuidString: "d5ef9020-e5af-45b3-b18d-5c03d7266c7d") ?? .init()]
    enum CodingKeys: String, CodingKey {
        case id, mates
    }
}

struct MateListDTO: Codable {
    let mates: [UUID]
}

struct MateListRequestDTO: Encodable {
    let userId: UUID
    
    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
    }
}

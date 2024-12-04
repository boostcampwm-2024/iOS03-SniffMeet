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
    let mates: [UUID] = [UUID(uuidString: "717765b9-2929-4a23-919b-3bb029f557fc") ?? .init(),
                         UUID(uuidString: "46432436-4dd7-4915-a2e7-c714c45146d1") ?? .init(),
                         UUID(uuidString: "1851b20f-57e4-4b37-b43c-b09b24393449") ?? .init(),
                         UUID(uuidString: "f1be0742-7f05-4049-b883-099d017d2f4e") ?? .init()]
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

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
    let mates: [UUID] = [
        UUID(uuidString: "f27c02f6-0110-4291-b866-a1ead0742755") ?? .init(),
        UUID(uuidString: "b79bc6b9-b776-4f5b-8f6c-48ba498b6e3a") ?? .init(),
        UUID(uuidString: "bda7ec28-1407-4871-93ea-c7835986726a") ?? .init(),
        UUID(uuidString: "a96ee934-03b9-43f3-b29b-53c3ba945363") ?? .init()
    ]
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

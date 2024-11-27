//
//  UserInfo.swift
//  SniffMeet
//
//  Created by Kelly Chui on 11/27/24.
//

import Foundation

/// Supabase 서버와 주고받을 유저의 정보입니다. DTO로 사용할 수 있습니다.
/// id: Supabase DB Table의 row에 접근한 권한이 있는지 확인하려면(RLS) id가 필요합니다.
/// profileImageURL: 프로필 이미지의 이름입니다.
struct UserInfo: Codable {
    let id: UUID
    let dogName: String
    let age: UInt8
    let sex: Sex
    let sexUponIntake: Bool
    let size: Size
    let keywords: [Keyword]
    let nickname: String
    let profileImageURL: String?

    enum CodingKeys: String, CodingKey {
        case id, age, sex, size, keywords, nickname
        case dogName = "dog_name"
        case sexUponIntake = "sex_upon_intake"
        case profileImageURL = "profile_image_url"
    }
}

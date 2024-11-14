//
//  DogDTO.swift
//  SniffMeet
//
//  Created by 윤지성 on 11/14/24.
//
import Foundation

struct DogDetailInfo {
    let name: String
    let age: UInt8
    let size: Size
    let keywords: [Keyword]
}

enum Size: Codable {
    case small
    case medium
    case big
}

enum Keyword: String, Codable  {
    case energetic = "활발한"
    case smart = "똑똑한"
    case friendly = "친화력 좋은"
    case shy = "소심한"
    case independent = "독립적인"
}


struct Dog: Codable {
    let name: String
    let age: UInt8
    let size: Size
    let keywords: [Keyword]
    let nickname: String
    let profileImage: Data?
}

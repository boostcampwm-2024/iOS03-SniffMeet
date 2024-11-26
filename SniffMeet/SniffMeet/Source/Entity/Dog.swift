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
    let sex: Sex
    let sexUponIntake: Bool
    let size: Size
    let keywords: [Keyword]
}

extension DogDetailInfo {
    static let example = DogDetailInfo(name: "후추",
                             age: 6,
                             sex: .female,
                             sexUponIntake: true,
                             size: .medium,
                             keywords: [.shy])
}

enum Sex: String, Codable {
    case male = "남"
    case female = "여"
}

enum Size: String, Codable {
    case small = "소형"
    case medium = "중형"
    case big = "대형"
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
    let sex: Sex
    let sexUponIntake: Bool
    let size: Size
    let keywords: [Keyword]
    let nickname: String
    let profileImage: Data?
}
 
extension Dog {
    static let example: Dog = Dog(name: "후추",
                                  age: 6,
                                  sex: .female,
                                  sexUponIntake: true,
                                  size: .medium,
                                  keywords: [.shy],
                                  nickname: "pear",
                                  profileImage: nil)
}


struct DogProfileInfo: Codable {
    let name: String
    let keywords: [Keyword]
    let profileImage: Data?
}

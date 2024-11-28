//
//  DogDTO.swift
//  SniffMeet
//
//  Created by 윤지성 on 11/14/24.
//
import Foundation

struct DogInfo {
    let name: String
    let age: UInt8
    let sex: Sex
    let sexUponIntake: Bool
    let size: Size
    let keywords: [Keyword]
}

struct UserInfo: Codable {
    let name: String
    let age: UInt8
    let sex: Sex
    let sexUponIntake: Bool
    let size: Size
    let keywords: [Keyword]
    let nickname: String
    let profileImage: Data?
}

extension UserInfo {
    static let example: UserInfo = UserInfo(name: "후추",
                                  age: 6,
                                  sex: .female,
                                  sexUponIntake: true,
                                  size: .medium,
                                  keywords: [.shy],
                                  nickname: "pear",
                                  profileImage: nil)
}

extension DogInfo {
    static let example = DogInfo(name: "후추",
                             age: 6,
                             sex: .female,
                             sexUponIntake: true,
                             size: .medium,
                             keywords: [.shy])
}

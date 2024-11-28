//
//  MateList.swift
//  SniffMeet
//
//  Created by 윤지성 on 11/28/24.
//
import Foundation

struct MateListDTO: Encodable {
    let id: UUID
    let mates: [UUID]
}

struct MateListResponseDTO: Decodable {
    let mates: [UserInfo]
}

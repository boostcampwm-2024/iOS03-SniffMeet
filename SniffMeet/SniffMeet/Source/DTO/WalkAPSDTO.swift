//
//  WalkAPSDTO.swift
//  SniffMeet
//
//  Created by sole on 11/28/24.
//

struct WalkAPSDTO: Decodable {
    let aps: APS
    let notification: WalkNotiDTO
}

struct APS: Decodable {
    let alert: Alert
}

struct Alert: Decodable {
    let title: String
    let subtitle: String
}

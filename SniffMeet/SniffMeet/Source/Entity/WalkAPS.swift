//
//  Walk.swift
//  SniffMeet
//
//  Created by sole on 11/28/24.
//

struct RequestAPS: Decodable {
    let aps: APS
    let categoryIdentifier: APSCategoryIdentifier
    let walkRequest: WalkNotiDTO
}

struct RespondAPS: Decodable {
    let aps: APS
    let categoryIdentifier: APSCategoryIdentifier
    let isAccepted: Bool
}

struct APS: Decodable {
    let alert: Alert
}

enum APSCategoryIdentifier: String, Decodable {
    case walkRequest
    case walkRespond
}

struct Alert: Decodable {
    let title: String
    let body: String
}

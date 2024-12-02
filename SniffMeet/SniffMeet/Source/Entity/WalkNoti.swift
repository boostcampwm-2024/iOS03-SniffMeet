//
//  WalkNoti.swift
//  SniffMeet
//
//  Created by 윤지성 on 11/20/24.
//

import Foundation

struct WalkRequest: Codable {
    let mate: UserInfo
    let address: Address
    let message: String
}

struct Address: Codable {
    let longtitude: Double
    let latitude: Double
    let location: String
    
    init(longtitude: Double, latitude: Double) {
        self.longtitude = longtitude
        self.latitude = latitude
        // TODO: -  경도와 위도를 가지고 주소를 변환 필요
        location = ""
    }
    init(longtitude: Double, latitude: Double, location: String) {
        self.longtitude = longtitude
        self.latitude = latitude
        self.location = location
    }
}

extension Address {
    static let example: Address = Address(longtitude: 12.0,
                                          latitude: 12.0,
                                          location: "서울 코드스쿼드")
}

struct WalkNoti {
    let id: UUID
    let createdAt: Date?
    let message: String
    let latitude: Double
    let longtitude: Double
    let senderId: UUID
    let senderName: String
    let category: WalkNotiCategory
}
extension WalkNoti {
    static let example = WalkNoti(id: UUID(),
                                  createdAt: Date.now,
                                  message: "산책하시죠",
                                  latitude: 11,
                                  longtitude: 11,
                                  senderId: UUID(),
                                  senderName: "지성",
                                  category: .walkRequest)
}

enum WalkNotiCategory: String, Codable {
    case walkRequest
    case walkAccepted
    case walkDeclined

    var label: String {
        switch self {
        case .walkRequest: "산책 요청"
        case .walkAccepted: "산책 수락"
        case .walkDeclined: "산책 거절"
        }
    }

    var description: String {
        switch self {
        case .walkRequest: "님이 산책 요청을 요청했어요!"
        case .walkAccepted: "님이 산책을 수락했어요!"
        case .walkDeclined: "님이 산책을 거절했어요..."
        }
    }
}

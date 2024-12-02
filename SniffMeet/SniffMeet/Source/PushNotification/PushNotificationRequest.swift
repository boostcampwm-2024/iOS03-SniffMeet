//
//  Untitled.swift
//  SniffMeet
//
//  Created by 윤지성 on 12/2/24.
//
import Foundation

enum PushNotificationRequest {
    case sendWalkRequest(data: Data)
    //case refreshUser(accessToken: String)
}

extension PushNotificationRequest: SNMRequestConvertible {
    var endpoint: Endpoint {
        switch self {
        case .sendWalkRequest(_):
            return Endpoint(
                baseURL: PushNotificationConfig.baseURL,
                path: "/notification/walkRequest",
                method: .post
            )
        }
    }
    
    var requestType: SNMRequestType {
        var header = [
            "Content-Type": "application/json"
        ]
        switch self {
        case .sendWalkRequest(let data):
            return SNMRequestType.compositePlain(
                header: header,
                body: data
            )
        }
    }
}


//
//  Untitled.swift
//  SniffMeet
//
//  Created by 윤지성 on 12/2/24.
//
import Foundation

enum PushNotificationRequest {
    case sendWalkRequest(data: Data)
    case sendWalkRespond(data: Data)
}

extension PushNotificationRequest: SNMRequestConvertible {
    var endpoint: Endpoint {
        switch self {
        case .sendWalkRequest:
            return Endpoint(
                baseURL: PushNotificationConfig.baseURL,
                path: "notification/walkRequest",
                method: .post
            )
        case .sendWalkRespond:
            return Endpoint(baseURL: PushNotificationConfig.baseURL,
                            path: "notification/walkRespond",
                            method: .post)
        }
    }
    
    var requestType: SNMRequestType {
        var header: [String: String] = [:]
        switch self {
        case .sendWalkRequest(let data):
            return SNMRequestType.compositePlain(
                header: header,
                body: data
            )
        case .sendWalkRespond(let data):
            return SNMRequestType.compositePlain(header: header,
                                                 body: data)
        }
    }
}

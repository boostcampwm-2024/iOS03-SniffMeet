//
//  SupabaseRequest.swift
//  SniffMeet
//
//  Created by Kelly Chui on 11/18/24.
//

import Foundation

enum SupabaseRequest {
    case signInAnonymously
    case refreshToken(refreshToken: String)
    case refreshUser(accessToken: String)
}

extension SupabaseRequest: SNMRequestConvertible {
    var endpoint: Endpoint {
        switch self {
        case .signInAnonymously:
            return Endpoint(
                baseURL: SupabaseConfig.baseURL,
                path: "auth/v1/signup",
                method: .post
            )
        case .refreshToken:
            return Endpoint(
                baseURL: SupabaseConfig.baseURL,
                path: "auth/v1/token",
                method: .post,
                query: [
                    "grant_type": "refreshToken"
                ]
            )
        case .refreshUser:
            return Endpoint(
                baseURL: SupabaseConfig.baseURL,
                path: "auth/v1/user",
                method: .get
            )
        }

    }
    var requestType: SNMRequestType {
        var header = [
            "Content-Type": "application/json",
            "Authorization": "Bearer \(SupabaseConfig.apiKey)",
            "apikey": SupabaseConfig.apiKey
        ]
        switch self {
        case .signInAnonymously:
            return SNMRequestType.compositePlain(
                header: header,
                body: Data("{}".utf8)
            )
        case .refreshToken(let refreshToken):
            return SNMRequestType.compositeJSONEncodable(
                header: header,
                body: SupabaseTokenRequest(refreshToken: refreshToken)
            )
        case .refreshUser(let accessToken):
            header["Authorization"] = "Bearer \(accessToken)"
            return SNMRequestType.header(
                with: header
            )
        }
    }
}

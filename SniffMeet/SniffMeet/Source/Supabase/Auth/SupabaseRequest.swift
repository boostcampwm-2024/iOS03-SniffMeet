//
//  SupabaseRequest.swift
//  SniffMeet
//
//  Created by Kelly Chui on 11/18/24.
//

import Foundation

enum SupabaseRequest {
    case signInAnonymously
    case refreshToken
    case refreshUser
    // case refreshSession
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
                    "grant_type": SupabaseConfig.session!.refreshToken // force unwrapping
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
        case .refreshToken:
            header["Authorization"] = "Bearer \(SupabaseConfig.session!.refreshToken)" // forceUnwrapping
            return SNMRequestType.compositeJSONEncodable(
                header: header,
                body: SupabaseRefreshTokenRequest(refreshToken: SupabaseConfig.session!.refreshToken) // forceUnwrapping
            )
        case .refreshUser:
            header["Authorization"] = "Bearer \(SupabaseConfig.session!.accessToken)" // forceUnwrapping
            return SNMRequestType.header(
                with: header
            )
        }
    }
}

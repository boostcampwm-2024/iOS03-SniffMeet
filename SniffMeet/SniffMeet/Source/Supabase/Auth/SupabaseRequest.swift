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
                    "grant_type": SessionManager.shared.session!.refreshToken // force unwrapping
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
            var refreshToken = ""
            if let token = SessionManager.shared.session?.refreshToken {
                refreshToken = token
            } else {
                do {
                    refreshToken = try KeychainManager.shared.get(forKey: "refreshToken")
                } catch {
                    // TODO: refresh Token을 찾을 수 없는 오류
                }
            }
            return SNMRequestType.compositeJSONEncodable(
                header: header,
                body: SupabaseTokenRequest(refreshToken: refreshToken) // forceUnwrapping
            )
        case .refreshUser:
            header["Authorization"] = "Bearer \(SessionManager.shared.session!.accessToken)" // forceUnwrapping
            return SNMRequestType.header(
                with: header
            )
        }
    }
}

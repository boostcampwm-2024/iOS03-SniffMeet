//
//  SupabaseStorageRequest.swift
//  SniffMeet
//
//  Created by Kelly Chui on 11/20/24.
//

import Foundation

enum SupabaseDatabaseRequest {
    case fetchData(table: String, accessToken: String)
    case insertData(table: String, accessToken: String, data: Data)
    // case updateData(table: String, accessToken: String)
}

extension SupabaseDatabaseRequest: SNMRequestConvertible {
    var endpoint: Endpoint {
        switch self {
        case .fetchData(let table, _):
            return Endpoint(
                baseURL: SupabaseConfig.baseURL,
                path: "rest/v1/\(table)",
                method: .get,
                query: nil
            )
        case .insertData(let table, _, _):
            return Endpoint(
                baseURL: SupabaseConfig.baseURL,
                path: "rest/v1/\(table)",
                method: .post,
                query: nil
            )
        }
    }
    var requestType: SNMRequestType {
        var header = [
            "Content-Type": "application/json",
            "apikey": SupabaseConfig.apiKey
        ]
        switch self {
        case .fetchData(_, let accessToken):
            header["Authorization"] = "Bearer \(accessToken)"
            return SNMRequestType.header(
                with: header
            )
        case .insertData(_, let accessToken, let data):
            header["Authorization"] = "Bearer \(accessToken)"
            return SNMRequestType.compositePlain(
                header: header,
                body: data
            )
        }
    }
}
//
//  SupabaseStorageRequest.swift
//  SniffMeet
//
//  Created by Kelly Chui on 11/20/24.
//

import Foundation

enum SupabaseDatabaseRequest {
    case fetchData(table: String, accessToken: String, query: [String: String])
    case fetchDataWithID(table: String, id: UUID, accessToken: String)
    case insertData(table: String, accessToken: String, data: Data)
    case updateData(table: String, accessToken: String, data: Data)
}

extension SupabaseDatabaseRequest: SNMRequestConvertible {
    var endpoint: Endpoint {
        switch self {
        case .fetchData(let table, _, let query):
            return Endpoint(
                baseURL: SupabaseConfig.baseURL,
                path: "rest/v1/\(table)",
                method: .get,
                query: query
            )
        case .fetchDataWithID(let table, let id, _):
            return Endpoint(
                baseURL: SupabaseConfig.baseURL,
                path: "rest/v1/\(table)",
                method: .get,
                query: ["id": "eq.\(id)"]
            )
        case .insertData(let table, _, _):
            return Endpoint(
                baseURL: SupabaseConfig.baseURL,
                path: "rest/v1/\(table)",
                method: .post,
                query: nil
            )
        case .updateData(let table, _, _):
            return Endpoint(
                baseURL: SupabaseConfig.baseURL,
                path: "rest/v1/\(table)",
                method: .patch,
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
        case .fetchData(_, let accessToken, _):
            header["Authorization"] = "Bearer \(accessToken)"
            return SNMRequestType.header(
                with: header
            )
        case .fetchDataWithID(_, _, let accessToken):
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
        case .updateData(_, let accessToken, let data):
            header["Authorization"] = "Bearer \(accessToken)"
            return SNMRequestType.compositePlain(
                header: header,
                body: data
            )
        }
    }
}

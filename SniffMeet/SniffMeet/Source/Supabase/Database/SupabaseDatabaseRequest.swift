//
//  SupabaseStorageRequest.swift
//  SniffMeet
//
//  Created by Kelly Chui on 11/20/24.
//

import Foundation

enum SupabaseDatabaseRequest {
    case fetchData(table: String, accessToken: String)
    case fetchDataWithID(table: String, id: UUID, accessToken: String)
    case insertData(table: String, accessToken: String, data: Data)
    case updateData(table: String, id: UUID, accessToken: String, data: Data)
    case fetchUserInfoFromMateList(data: Data, accessToken: String)
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
        case .updateData(let table, let id, _, _):
            return Endpoint(
                baseURL: SupabaseConfig.baseURL,
                path: "rest/v1/\(table)",
                method: .patch,
                query: ["id": "eq.\(id)"]
            )
            
        case .fetchUserInfoFromMateList( _, _):
            return Endpoint(
                baseURL: SupabaseConfig.baseURL,
                path: "rest/v1/rpc/get_user_info_from_mate_list",
                method: .post // SQL 함수 호출은 POST 요청으로 수행
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
        case .updateData(_, _, let accessToken, let data):
            header["Authorization"] = "Bearer \(accessToken)"
            return SNMRequestType.compositePlain(
                header: header,
                body: data
            )
        case .fetchUserInfoFromMateList(let data, let accessToken):
            header["Authorization"] = "Bearer \(accessToken)"
            
            return SNMRequestType.compositePlain(
                header: header,
                body: data
            )
        }
    }
}

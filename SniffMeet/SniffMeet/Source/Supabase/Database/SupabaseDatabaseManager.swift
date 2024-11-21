//
//  SupabaseDatabaseManager.swift
//  SniffMeet
//
//  Created by Kelly Chui on 11/20/24.
//

import Combine
import Foundation

protocol RemoteDatabaseManager {
    static var shared: RemoteDatabaseManager { get }
    func fetchData(from table: String) async throws -> Data
    func insertData(into table: String, with data: Data) async throws
    // func updateData()
}

enum DatabaseState: String, CaseIterable {
    case fetchData
    case insertData
}

final class SupabaseDatabaseManager: RemoteDatabaseManager {
    static let shared: RemoteDatabaseManager = SupabaseDatabaseManager()
    var databaseStateSubject: PassthroughSubject<DatabaseState, Never>
    private let networkProvider: SNMNetworkProvider
    private let decoder: JSONDecoder

    private init() {
        databaseStateSubject = PassthroughSubject<DatabaseState, Never>()
        networkProvider = SNMNetworkProvider()
        decoder = JSONDecoder()
    }

    func fetchData(from table: String) async throws -> Data {
        if SessionManager.shared.isExpired {
            try await SupabaseAuthManager.shared.refreshSession()
        }
        guard let session = SessionManager.shared.session else {
            throw SupabaseError.sessionNotExist
        }
        let response = try await networkProvider.request(
            with: SupabaseDatabaseRequest.fetchData(
                table: table,
                accessToken: session.accessToken
            )
        )
        databaseStateSubject.send(.fetchData)
        return response.data
    }

    func insertData(into table: String, with data: Data) async throws {
        if SessionManager.shared.isExpired {
            try await SupabaseAuthManager.shared.refreshSession()
        }
        guard let session = SessionManager.shared.session else {
            throw SupabaseError.sessionNotExist
        }
        _ = try await networkProvider.request(
            with: SupabaseDatabaseRequest.insertData(
                table: table,
                accessToken: session.accessToken,
                data: data
            )
        )
        databaseStateSubject.send(.insertData)
    }
}

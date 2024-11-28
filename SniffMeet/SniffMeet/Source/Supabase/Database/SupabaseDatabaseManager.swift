//
//  SupabaseDatabaseManager.swift
//  SniffMeet
//
//  Created by Kelly Chui on 11/20/24.
//

import Combine
import Foundation

protocol RemoteDatabaseManager {
    func fetchData(from table: String) async throws -> Data
    func insertData(into table: String, with data: Data) async throws
    func updateData(into table: String, with data: Data) async throws
}

enum DatabaseState {
    case fetchData
    case insertData
    case updateData
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

    func updateData(into table: String, with data: Data) async throws {
        if SessionManager.shared.isExpired {
            try await SupabaseAuthManager.shared.refreshSession()
        }
        guard let session = SessionManager.shared.session else {
            throw SupabaseError.sessionNotExist
        }
        guard let userID = SessionManager.shared.session?.user?.userID else { return }
        
        _ = try await networkProvider.request(
            with: SupabaseDatabaseRequest.updateData(
                table: table,
                id: userID,
                accessToken: session.accessToken,
                data: data
            )
        )
        databaseStateSubject.send(.insertData)
    }
}

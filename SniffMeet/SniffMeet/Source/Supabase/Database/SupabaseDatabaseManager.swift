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
    func fetchValue(from table: String) async throws -> Data
    func insertValue(into table: String, with value: Data) async throws
    // func updateValue()
}

enum DatabaseState: String, CaseIterable {
    case fetchValue
    case insertValue
}

final class SupabaseDatabaseManager: RemoteDatabaseManager {
    var storageStateSubject: PassthroughSubject<DatabaseState, Never>
    private let networkProvider: SNMNetworkProvider
    private let decoder: JSONDecoder
    private var cancellables: Set<AnyCancellable>
    static let shared: RemoteDatabaseManager = SupabaseDatabaseManager()

    private init() {
        storageStateSubject = PassthroughSubject<DatabaseState, Never>()
        networkProvider = SNMNetworkProvider()
        decoder = JSONDecoder()
        cancellables = Set<AnyCancellable>()
    }

    func fetchValue(from table: String) async throws -> Data {
        if SessionManager.shared.isExpired {
            try await SupabaseAuthManager.shared.refreshSession()
        }
        guard let session = SessionManager.shared.session else {
            throw SupabaseError.sessionNotExist
        }
        let response = try await networkProvider.request(
            with: SupabaseDatabaseRequest.fetchValue(
                table: table,
                accessToken: session.accessToken
            )
        )
        return response.data
    }

    func insertValue(into table: String, with value: Data) async throws {
        if SessionManager.shared.isExpired {
            try await SupabaseAuthManager.shared.refreshSession()
        }
        guard let session = SessionManager.shared.session else {
            throw SupabaseError.sessionNotExist
        }
        _ = try await networkProvider.request(
            with: SupabaseDatabaseRequest.insertValue(
                table: table,
                accessToken: session.accessToken,
                data: value
            )
        )
    }
}

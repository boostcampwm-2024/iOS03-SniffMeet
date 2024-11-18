//
//  AuthManager.swift
//  SniffMeet
//
//  Created by Kelly Chui on 11/16/24.
//

import Combine
import Foundation

protocol AuthManager {
    static var shared: AuthManager { get }
    var authStateSubject: PassthroughSubject<AuthState, Never> { get set }
    func signInAnonymously() async
    func saveSession(for session: SupabaseSession) throws
}

enum AuthState: String, CaseIterable {
    case signInSucced
    case signInFailed
    case signInAnonymously
}

final class SupabaseAuthManager: AuthManager {
    var authStateSubject: PassthroughSubject<AuthState, Never>
    private let networkProvider: SNMNetworkProvider
    private let decoder: JSONDecoder
    private var cancellables: Set<AnyCancellable>

    static let shared: AuthManager = SupabaseAuthManager()

    private init() {
        authStateSubject = PassthroughSubject<AuthState, Never>()
        networkProvider = SNMNetworkProvider()
        decoder = JSONDecoder()
        cancellables = Set<AnyCancellable>()
    }

    func signInAnonymously() async {
        do {
            let response = try await networkProvider.request(
                with: SupabaseRequest.signInAnonymously
            )
            let sessionResponse = try decoder.decode(SupabaseSessionResponse.self, from: response.data)
            try saveSession(for: SupabaseSession(from: sessionResponse))
            authStateSubject.send(.signInSucced)
        } catch {
            // TODO: 실패 처리 결정
            print(error)
        }
    }

    func saveSession(for session: SupabaseSession) throws {
        SupabaseConfig.session = session
        try KeychainManager.shared.set(value: session.accessToken, forKey: "accessToken")
        try KeychainManager.shared.set(value: session.refreshToken, forKey: "refreshToken")
    }

    func restoreSession() async {
        do {
            let accessToken = try KeychainManager.shared.get(forKey: "accessToken")
            let refreshToken = try KeychainManager.shared.get(forKey: "refreshToken")
            let response = try await networkProvider.request(
                with: SupabaseRequest.refreshUser
            )
            let userResponse = try decoder.decode(SupabaseUserResponse.self, from: response.data)
            try saveSession(for: SupabaseSession(from: sessionResponse))
            authStateSubject.send(.signInSucced)
        } catch {
            // TODO: 실패 처리 결정
            // 세션 복원 실패 -> 처음 실행
            print(error)
        }
    }

    func refreshSession() {
        // 세션 갱신
        // method: POST
        // url: https://lltjsznuclppbhxfwslo.supabase.co/auth/v1/token?grant_type=refresh_token
        // Header:
        //  Content-Type: application/json
        //  Authorization: Bearer <access-token>
        //  apikey: <anon-key>
        // body: { "refresh_token": <refresh_token>}
        //
    }
}

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
    func restoreSession() async throws
    func refreshSession() async throws
    func loadTokens() throws
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
            let sessionResponse = try decoder.decode(
                SupabaseSessionResponse.self,
                from: response.data)
            try saveSession(for: SupabaseSession(
                accessToken: sessionResponse.accessToken,
                expiresAt: sessionResponse.expiresAt,
                refreshToken: sessionResponse.refreshToken,
                user: SupabaseUser(from: sessionResponse.user)
            ))
            authStateSubject.send(.signInSucced)
        } catch {
            // TODO: 실패 처리 결정
        }
    }

    func restoreSession() async throws { // 세션 복원
        // 키체인에서 토큰 가져와서 일단 만료랑 상관없이 세션 업데이트
        try loadTokens()
        try await refreshSession() // 세션 갱신 진행
    }

    func refreshSession() async throws { // 세션 갱신
        // 세션에서 토큰 가져옴
        guard let refreshToken = SessionManager.shared.session?.refreshToken else {
            throw SupabaseAuthError.sessionNotExist
        }
        // 가져온 토큰으로 갱신 요청
        let response = try await networkProvider.request(
            with: SupabaseRequest.refreshToken(refreshToken: refreshToken)
        )
        let sessionResponse = try decoder.decode(
            SupabaseSessionResponse.self,
            from: response.data
        )
        // 새로 받아온 토큰으로 세션 업데이트
        try saveSession(for: SupabaseSession(
            accessToken: sessionResponse.accessToken,
            expiresAt: sessionResponse.expiresAt,
            refreshToken: sessionResponse.refreshToken,
            user: SupabaseUser(from: sessionResponse.user)
        ))
    }

    func loadTokens() throws {
        let accessToken = try KeychainManager.shared.get(forKey: "accessToken")
        let refreshToken = try KeychainManager.shared.get(forKey: "refreshToken")
        let expiresAt = try UserDefaultsManager.shared.get(forKey: "expiresAt", type: Int.self)
        SessionManager.shared.session = SupabaseSession(
            accessToken: accessToken,
            expiresAt: expiresAt,
            refreshToken: refreshToken
        )
    }

    private func saveSession(for session: SupabaseSession?) throws {
        guard let session else { throw SupabaseAuthError.sessionNotExist }
        SessionManager.shared.session = session
        try KeychainManager.shared.set(value: session.accessToken, forKey: "accessToken")
        try KeychainManager.shared.set(value: session.refreshToken, forKey: "refreshToken")
        try UserDefaultsManager.shared.set(value: session.expiresAt, forKey: "expiresAt")
    }
}

//
//  AuthManager.swift
//  SniffMeet
//
//  Created by Kelly Chui on 11/16/24.
//

import Combine
import UIKit

protocol AuthManager {
    static var shared: AuthManager { get }
    var signedInSubject: PassthroughSubject<AuthState, Never> { get set }
}

enum AuthState: String, CaseIterable {
    case signInSucced
    case signInFailed
    case signInAnonymously
}

final class SupabaseAuthManager: AuthManager {
    static let shared: AuthManager = SupabaseAuthManager()
    var signedInSubject: PassthroughSubject<AuthState, Never> = .init()

    func signInAnonymously() {
        // 익명 사용자 생성 & 로그인 로직
        // method: POST
        // url: https://lltjsznuclppbhxfwslo.supabase.co/auth/v1/signup
        // Header:
        //  Content-Type: application/json
        //  Authorization: Bearer <anon-key>
        //  apikey: <anon-key>
        // body: {}
        //
        // 통신해서 세션 받아오기 -> 세션 업데이트 하기 -> (access, refresh)키체인에 저장하기
    }

    func saveSession() {
        // 세션 저장
        // 키체인에 access, refresh 저장하기
    }

    func restoreSession() {
        // 세션 복원
        // 키체인에서 access 불러오기, 만약 만료되었다면 복원 진행
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

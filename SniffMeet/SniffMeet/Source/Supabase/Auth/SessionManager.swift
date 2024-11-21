//
//  SessionManager.swift
//  SniffMeet
//
//  Created by Kelly Chui on 11/19/24.
//

import Combine
import Foundation

final class SessionManager {
    static let shared = SessionManager()
    var session: SupabaseSession?
    var isExpired: Bool {
        guard let session else { return true }
        // 세션 만료를 파악할 때는 30초의 여유시간을 줍니다.
        return Date(timeIntervalSince1970: TimeInterval(session.expiresAt + 30)) < Date()
    }

    private init() {}
}

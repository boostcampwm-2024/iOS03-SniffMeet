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
//    var isExpiredSubject: CurrentValueSubject<Bool, Never>
    var isExpired: Bool {
        guard let session else { return true }
        return Date(timeIntervalSince1970: TimeInterval(session.expiresAt)) < Date()
    }

    private init() {
//        isExpiredSubject = CurrentValueSubject()
    }
}

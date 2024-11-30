//
//  RequestNotificationAuthUseCase.swift
//  SniffMeet
//
//  Created by sole on 11/28/24.
//

import UserNotifications

protocol RequestNotificationAuthUseCase {
    func execute() async throws -> Bool
}

struct RequestNotificationAuthUseCaseImpl: RequestNotificationAuthUseCase {
    private let userNotificationCenter: UNUserNotificationCenter

    init(userNotificationCenter: UNUserNotificationCenter = .current()) {
        self.userNotificationCenter = userNotificationCenter
    }

    func execute() async throws -> Bool {
        try await userNotificationCenter.requestAuthorization(options: [.alert, .badge, .sound])
    }
}

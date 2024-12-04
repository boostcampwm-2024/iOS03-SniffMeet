//
//  AppDelegate.swift
//  SniffMeet
//
//  Created by sole on 11/4/24.
//

import UIKit

@main
final class AppDelegate: UIResponder, UIApplicationDelegate {
    private let convertToWalkAPS: any ConvertToWalkAPSUseCase = ConvertToWalkAPSUseCaseImpl()

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        UNUserNotificationCenter.current().delegate = self
        UIApplication.shared.registerForRemoteNotifications()
        return true
    }
    func application(
        _ application: UIApplication,
        didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
    ) {
        let registerDeviceTokenUseCase = RegisterDeviceTokenUseCaseImpl(
            keychainManager: KeychainManager.shared
        )
        do {
            try registerDeviceTokenUseCase.execute(deviceToken: deviceToken)
        } catch {
            SNMLogger.error("device token register \(error.localizedDescription)")
        }
    }
    func application(
        _ application: UIApplication,
        didFailToRegisterForRemoteNotificationsWithError error: any Error
    ) {
        SNMLogger.error("deviceToken 등록 실패", error.localizedDescription)
    }
}

// MARK: - AppDelegatev+UNUserNotificationCenterDelegate

extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification
    ) async -> UNNotificationPresentationOptions {
        [.list, .banner, .badge]
    }
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse
    ) async {
        guard let sceneDelegate = UIApplication.shared.connectedScenes
            .first?.delegate as? SceneDelegate else {
            return
        }
        let userInfo = response.notification.request.content.userInfo
        guard let walkAPS = convertToWalkAPS.execute(walkAPSUserInfo: userInfo) else { return }
        let walkNoti: WalkNoti = walkAPS.notification.toEntity()
        switch walkAPS.notification.category {
        case .walkRequest:
            sceneDelegate.appRouter?.presentRespondWalkView(walkNoti: walkNoti)
        case .walkAccepted, .walkDeclined:
            sceneDelegate.appRouter?.presentRespondWalkView(walkNoti: walkNoti)
        }
    }
}

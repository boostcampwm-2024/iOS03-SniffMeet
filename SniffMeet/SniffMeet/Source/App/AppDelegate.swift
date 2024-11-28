//
//  AppDelegate.swift
//  SniffMeet
//
//  Created by sole on 11/4/24.
//

import UIKit

@main
final class AppDelegate: UIResponder, UIApplicationDelegate {
    private let convertToRequestAPS: any ConvertToRequestAPSUseCase = ConverToRequestAPSUseCaseImpl()
    private let convertToResponsdAPS: any ConvertToRespondAPSUseCase = ConvertToRespondAPSUseCaseImpl()

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
        let registerDeviceTokenUseCase = RegisterDeviceTokenUseCaseImpl(keychainManager: KeychainManager.shared)
        Task {
            do {
                try await registerDeviceTokenUseCase.execute(deviceToken: deviceToken)
            } catch {
                SNMLogger.error(error.localizedDescription)
            }
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
        if let requestAPS = convertToRequestAPS.execute(userInfo: userInfo) {
            sceneDelegate.appRouter?.presentWalkRequestView(walkNoti: requestAPS.walkRequest.toEntity())
        } else if let respondAPS = convertToResponsdAPS.execute(userInfo: userInfo) {
            // TODO: 산책 거절 / 수락 화면으로 라우팅
            sceneDelegate.appRouter?.presentRespondWalkView(isAccepted: respondAPS.isAccepted)
        }
    }
}

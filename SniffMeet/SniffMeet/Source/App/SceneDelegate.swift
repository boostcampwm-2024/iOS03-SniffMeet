//
//  SceneDelegate.swift
//  SniffMeet
//
//  Created by sole on 11/4/24.
//

import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    var appRouter: AppRouter?
    private let convertToRequestAPS: any ConvertToWalkAPSUseCase = ConvertToWalkAPSUseCaseImpl()

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        appRouter = AppRouter(window: window)

        if let response = connectionOptions.notificationResponse {
            routePushNotification(response: response)
            return
        }
        appRouter?.displayInitialScreen()
    }

    /// push notification을 통해 앱에 처음 진입한 경우 라우팅을 진행합니다.
    private func routePushNotification(response: UNNotificationResponse) {
        let userInfo = response.notification.request.content.userInfo
        guard let requestAPS = convertToRequestAPS.execute(userInfo: userInfo) else {
            appRouter?.displayInitialScreen()
            return
        }
        let walkNoti: WalkNoti = requestAPS.notification.toEntity()
        switch requestAPS.notification.category {
        case .walkRequest:
            appRouter?.initializeViewAndPresentRequestView(walkNoti: walkNoti)
        case .walkAccepted, .walkDeclined:
            appRouter?.initializeViewAndPresentRespondView(walkNoti: walkNoti)
        }
    }
}

//
//  SceneDelegate.swift
//  SniffMeet
//
//  Created by sole on 11/4/24.
//

import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        let submodules = (
            home: HomeModuleBuilder.build(),
            walk: UIViewController(),
            mate: UIViewController()
        )

        let tabBarController = TabBarModuleBuilder.build(usingSubmodules: submodules)
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
    }
}

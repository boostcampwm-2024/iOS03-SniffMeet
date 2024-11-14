//
//  AppRouter.swift
//  SniffMeet
//
//  Created by Kelly Chui on 11/12/24.
//

import UIKit

final class AppRouter {
    private var window: UIWindow?

    init(window: UIWindow?) {
        self.window = window
    }
    func displayInitialScreen(isLoggedIn: Bool) {
        if isLoggedIn {
            displayTabBar()
        } else {
            displayProfileSetupView()
        }
    }
    private func displayTabBar() {
        let submodules = (
            home: UINavigationController(rootViewController:  HomeModuleBuilder.build()),
            walk: UIViewController(),
            mate: UIViewController()
        )
        window?.rootViewController = TabBarModuleBuilder.build(usingSubmodules: submodules)
        window?.makeKeyAndVisible()
    }
    private func displayProfileSetupView() {
        let navigationController =
        UINavigationController(rootViewController: ProfileInputRouter.createProfileInputModule())
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
    
    func moveToHomeScreen() {
        let submodules = (
            home: UINavigationController(rootViewController:  HomeModuleBuilder.build()),
            walk: UIViewController(),
            mate: UIViewController()
        )
        window?.rootViewController = TabBarModuleBuilder.build(usingSubmodules: submodules)
    }
}

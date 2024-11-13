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

    // 첫 화면을 뭘 보여줄지는 회원 가입 여부에 따라 앱 플로우가 다르므로, UIWindow를 이용해야 합니다.
    func displayInitialScreen(isLoggedIn: Bool) {
        if isLoggedIn {
            displayTabBar()
        } else {
            displayProfileSetupView()
        }
    }
    private func displayTabBar() {
        let submodules = (
            home: HomeModuleBuilder.build(),
            walk: UIViewController(),
            mate: UIViewController()
        )
        window?.rootViewController = TabBarModuleBuilder.build(usingSubmodules: submodules)
        window?.makeKeyAndVisible()
    }
    private func displayProfileSetupView() {
        let profileViewController = ProfileInputView()
        window?.rootViewController = profileViewController
        window?.makeKeyAndVisible()
    }
}

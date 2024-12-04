//
//  AppRouter.swift
//  SniffMeet
//
//  Created by Kelly Chui on 11/12/24.
//

import UIKit

final class AppRouter: NSObject, Routable {
    private var window: UIWindow?

    init(window: UIWindow?) {
        self.window = window
        super.init()
    }

    func displayInitialScreen() {
        Task { @MainActor in
            do {
                try await SupabaseAuthManager.shared.restoreSession()
                displayTabBar()
            } catch {
                displayOnBoardingView()
            }
        }
    }
    private func displayTabBar() {
        let submodules = (
            home: UINavigationController(rootViewController: HomeModuleBuilder.build()),
            walk: UINavigationController(rootViewController: WalkLogPageViewController()),
            mate: UINavigationController(rootViewController: MateListRouter.createMateListModule())
        )
        window?.rootViewController = TabBarModuleBuilder.build(usingSubmodules: submodules)
        window?.makeKeyAndVisible()
    }
    private func displayOnBoardingView() {
        let navigationController =
        UINavigationController(rootViewController: OnBoardingRouter.createModule())
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
    func displayProfileSetupView() {
        let navigationController =
        UINavigationController(rootViewController: ProfileInputRouter.createProfileInputModule())
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
    func moveToHomeScreen() {
        let submodules = (
            home: UINavigationController(rootViewController:  HomeModuleBuilder.build()),
            walk: UINavigationController(rootViewController: WalkLogPageViewController()),
            mate: UINavigationController(rootViewController: MateListRouter.createMateListModule())
        )
        window?.rootViewController = TabBarModuleBuilder.build(usingSubmodules: submodules)
    }
    /// 뷰에 진입한 후 산책 요청 화면을 present 합니다.
    func initializeViewAndPresentRequestView(walkNoti: WalkNoti) {
        Task { @MainActor in
            do {
                try await SupabaseAuthManager.shared.restoreSession()
                displayTabBar()
                presentWalkRequestView(walkNoti: walkNoti)
            } catch {
                displayProfileSetupView()
            }
        }
    }
    /// 뷰에 진입한 후 산책 응답 화면을 present 합니다.
    func initializeViewAndPresentRespondView(walkNoti: WalkNoti) {
        Task { @MainActor in
            do {
                try await SupabaseAuthManager.shared.restoreSession()
                displayTabBar()
                presentRespondWalkView(walkNoti: walkNoti)
            } catch {
                displayProfileSetupView()
            }
        }
    }
    func presentWalkRequestView(walkNoti: WalkNoti) {
        let requestWalkViewController =
        RespondWalkRouter.createRespondtWalkModule(walkNoti: walkNoti)
        presentCardViewController(viewController: requestWalkViewController)
    }
    func presentRespondWalkView(walkNoti: WalkNoti) {
        let respondWalkViewController = RespondWalkRouter.createRespondtWalkModule(
            walkNoti: walkNoti
        )
        presentCardViewController(viewController: respondWalkViewController)
    }
    private func presentCardViewController(viewController: UIViewController) {
        viewController.modalPresentationStyle = .custom
        viewController.transitioningDelegate = self
        if let rootViewController = UIViewController.topMostViewController {
            present(from: rootViewController, with: viewController, animated: true)
        }
    }
}

// MARK: - AppRouter+UIViewControllerTransitioningDelegate

extension AppRouter: UIViewControllerTransitioningDelegate {
    func presentationController(
        forPresented presented: UIViewController,
        presenting: UIViewController?,
        source: UIViewController
    ) -> UIPresentationController? {
        CardPresentationController(
            presentedViewController: presented,
            presenting: presenting
        )
    }
}

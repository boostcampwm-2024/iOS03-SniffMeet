//
//  OnBoardingRouter.swift
//  SniffMeet
//
//  Created by 배현진 on 12/4/24.
//

import UIKit

protocol OnBoardingRoutable {
    func navigateToMainScreen()
}

protocol OnBoardingBuilable {
    static func createModule() -> UIViewController
}

final class OnBoardingRouter: OnBoardingRoutable {

    func navigateToMainScreen() {
        Task { @MainActor in
            if let sceneDelegate = UIApplication.shared.connectedScenes
                .first(where: { $0.activationState == .foregroundActive })?
                .delegate as? SceneDelegate {
                if let router = sceneDelegate.appRouter {
                    router.displayProfileSetupView()
                }
            }
        }
    }
}

extension OnBoardingRouter: OnBoardingBuilable {
    static func createModule() -> UIViewController {
        let view = OnBoardingViewController()
        let interactor = OnBoardingInteractor()
        let router: OnBoardingRoutable & OnBoardingBuilable = OnBoardingRouter()
        let presenter: OnBoardingPresentable = OnBoardingPresenter()

        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        interactor.presenter = presenter

        return view
    }
}

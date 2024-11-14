//
//  ProfileCreateRouter.swift
//  SniffMeet
//
//  Created by 윤지성 on 11/14/24.
//
import UIKit

protocol ProfileCreateRoutable {
    static func createProfileCreateModule() -> UIViewController
    func presentMainScreen(from view: ProfileCreateViewable)
}

final class ProfileCreateRouter: ProfileCreateRoutable {
    static func createProfileCreateModule() -> UIViewController {
        let view: ProfileCreateViewable & UIViewController = ProfileCreateViewController()
        var presenter: ProfileCreatePresentable = ProfileCreatePresenter()
        let interactor: ProfileCreateInteractable = ProfileCreateInteractor()
        let router: ProfileCreateRoutable = ProfileCreateRouter()

        view.presenter = presenter
        presenter.view = view
        presenter.router = router
        presenter.interactor = interactor
        interactor.presenter = presenter

        return view
    }
    
    func presentMainScreen(from view: any ProfileCreateViewable) {
        
    }
}

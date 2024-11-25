//
//  MateListRouter.swift
//  SniffMeet
//
//  Created by Kelly Chui on 11/21/24.
//

import UIKit

protocol MateListRoutable: Routable {
    
}

protocol MateListBuildable {
    static func createMateListModule() -> UIViewController
}

struct MateListRouter: MateListRoutable {
    
}

extension MateListRouter: MateListBuildable {
    static func createMateListModule() -> UIViewController {
        let requestMateListUseCase: RequestMateListUseCase = RequestMateListUseCaseImpl()
        let requestProfileImageUseCase: RequestProfileImageUseCase = RequestProfileImageUseCaseImpl()

        let view: MateListViewable & UIViewController = MateListViewController()
        let presenter: MateListPresentable & MateListInteractorOutput =
        MateListPresenter()
        let interactor: MateListInteractable = MateListInteractor(
            requestMateListUseCase: requestMateListUseCase,
            requestProfileImageUseCase: requestProfileImageUseCase)

        let router: MateListRoutable & MateListBuildable = MateListRouter()

        view.presenter = presenter
        presenter.view = view
        presenter.router = router
        presenter.interactor = interactor
        interactor.presenter = presenter

        return view
    }
}
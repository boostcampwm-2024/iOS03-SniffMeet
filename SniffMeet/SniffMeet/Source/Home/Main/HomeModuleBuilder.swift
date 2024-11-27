//
//  HomeModuleBuilder.swift
//  SniffMeet
//
//  Created by Kelly Chui on 11/11/24.
//

import UIKit

enum HomeModuleBuilder {
    static func build() -> UIViewController {
        let view = HomeViewController()
        let router = HomeRouter()
        let interactor = HomeInteractor(
            loadUserInfoUseCase: LoadUserInfoUseCaseImpl(
                dataLoadable: LocalDataManager()
            )
        )
        view.presenter = HomePresenter(view: view, router: router, interactor: interactor)
        interactor.presenter = view.presenter
        return view
    }
}

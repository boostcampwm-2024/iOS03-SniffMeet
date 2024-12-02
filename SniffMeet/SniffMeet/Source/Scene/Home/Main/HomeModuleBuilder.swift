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
                dataLoadable: LocalDataManager(),
                imageManageable: SNMFileManager()
            ),
            checkFirstLaunchUseCase: CheckFirstLaunchUseCaseImpl(
                userDefaultsManager: UserDefaultsManager.shared
            ),
            saveFirstLaunchUseCase: SaveFirstLaunchUseCaseImpl(
                userDefaultsManager: UserDefaultsManager.shared
            ),
            requestNotificationAuthUseCase: RequestNotificationAuthUseCaseImpl(),
            remoteSaveDeviceTokenUseCase: RemoteSaveDeviceTokenUseCaseImpl(
                jsonEncoder: JSONEncoder(),
                keychainManager: KeychainManager.shared,
                remoteDBManager: SupabaseDatabaseManager.shared
            )
        )
        view.presenter = HomePresenter(view: view, router: router, interactor: interactor)
        interactor.presenter = view.presenter
        return view
    }
}

//
//  ProfileEditRoutable.swift
//  SniffMeet
//
//  Created by Kelly Chui on 12/1/24.
//

import UIKit

protocol ProfileEditRoutable: Routable {
    func presentMainScreen(from view: ProfileEditViewable)
}

protocol ProfileEditBuildable {
    static func createProfileEditModule(userInfo: UserInfo) -> UIViewController
}

final class ProfileEditRouter: ProfileEditRoutable {
    func presentMainScreen(from view: any ProfileEditViewable) {
        Task { @MainActor in
            pop(from: view as! UIViewController, animated: true)
        }
    }
}

extension ProfileEditRouter: ProfileEditBuildable {
    static func createProfileEditModule(userInfo: UserInfo) -> UIViewController {
        let saveUserInfoUseCase: SaveUserInfoUseCase = SaveUserInfoUseCaseImpl(
            localDataManager: LocalDataManager(),
            imageManager: SNMFileManager()
        )
        let updateUserInfoRemoteUseCase: UpdateUserInfoUseCase = UpdateUserInfoUseCaseImpl()
        let saveProfileImageUseCase: SaveProfileImageUseCase = SaveProfileImageUseCaseImpl(
            remoteImageManager: SupabaseStorageManager(
            networkProvider: SNMNetworkProvider()
            ),
            userDefaultsManager: UserDefaultsManager.shared
        )
        let view: ProfileEditViewable & UIViewController = ProfileEditViewController()
        let router: ProfileEditRoutable & ProfileEditBuildable = ProfileEditRouter()
        let interactor: ProfileEditInteractable = ProfileEditInteractor(
                saveUserInfoUseCase: saveUserInfoUseCase,
                updateUserInfoRemoteUseCase: updateUserInfoRemoteUseCase,
                saveProfileImageUseCase: saveProfileImageUseCase,
                loadUserInfoUseCase: LoadUserInfoUseCaseImpl(
                dataLoadable: LocalDataManager(),
                imageManageable: SNMFileManager()
            )
        )
        let presenter: ProfileEditPresentable & ProfileEditInteractorOutput =
        ProfileEditPresenter(userInfo: userInfo)

        view.presenter = presenter
        presenter.view = view
        presenter.router = router
        presenter.interactor = interactor
        interactor.presenter = presenter

        return view
    }
}

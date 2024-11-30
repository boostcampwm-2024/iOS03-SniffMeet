//
//  ProfileCreateRouter.swift
//  SniffMeet
//
//  Created by 윤지성 on 11/14/24.
//
import UIKit

protocol ProfileCreateRoutable {
    func presentMainScreen(from view: ProfileCreateViewable)
}

protocol ProfileCreateBuildable {
    static func createProfileCreateModule(dogDetailInfo: DogInfo) -> UIViewController
}

final class ProfileCreateRouter: ProfileCreateRoutable {
    func presentMainScreen(from view: any ProfileCreateViewable) {
        Task { @MainActor in
            if let sceneDelegate = UIApplication.shared.connectedScenes
                .first(where: { $0.activationState == .foregroundActive })?
                .delegate as? SceneDelegate {
                if let router = sceneDelegate.appRouter {
                    router.moveToHomeScreen()
                }
            }
        }
    }
}

extension ProfileCreateRouter: ProfileCreateBuildable {
    static func createProfileCreateModule(dogDetailInfo: DogInfo) -> UIViewController {
        let saveUserInfoUseCase: SaveUserInfoUseCase =
        SaveUserInfoUseCaseImpl(
            localDataManager: LocalDataManager(),
            imageManager: SNMFileManager()
        )
        let saveProfileImageUseCase: SaveProfileImageUseCase =
        SaveProfileImageUseCaseImpl(
            remoteImageManager: SupabaseStorageManager(
                networkProvider: SNMNetworkProvider()
            ),
            userDefaultsManager: UserDefaultsManager.shared
        )
        let createAccountUseCase: CreateAccountUseCase = CreateAccountUseCaseImpl()

        let view: ProfileCreateViewable & UIViewController = ProfileCreateViewController()
        let presenter: ProfileCreatePresentable & DogInfoInteractorOutput
        = ProfileCreatePresenter(dogInfo: dogDetailInfo)
        let interactor: ProfileCreateInteractable =
        ProfileCreateInteractor(
            saveUserInfoUseCase: saveUserInfoUseCase,
            saveProfileImageUseCase: saveProfileImageUseCase,
            saveUserInfoRemoteUseCase: createAccountUseCase
        )
        let router: ProfileCreateRoutable & ProfileCreateBuildable = ProfileCreateRouter()

        view.presenter = presenter
        presenter.view = view
        presenter.router = router
        presenter.interactor = interactor
        interactor.presenter = presenter

        return view
    }
    
}

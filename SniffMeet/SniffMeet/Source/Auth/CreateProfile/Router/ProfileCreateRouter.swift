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
    static func createProfileCreateModule(dogDetailInfo: DogDetailInfo) -> UIViewController
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
    static func createProfileCreateModule(dogDetailInfo: DogDetailInfo) -> UIViewController {
        let storeDogInfoUsecase: StoreDogInfoUseCase =
        StoreDogInfoUseCaseImpl(localDataManager: LocalDataManager())
        let saveProfileImageUsecase: SaveProfileImageUseCase =
        SaveProfileImageUseCaseImpl(
            remoteImageManager: SupabaseStorageManager(
                networkProvider: SNMNetworkProvider()
            ),
            userDefaultsManager: UserDefaultsManager.shared
        )

        let view: ProfileCreateViewable & UIViewController = ProfileCreateViewController()
        let presenter: ProfileCreatePresentable & DogInfoInteractorOutput
        = ProfileCreatePresenter(dogInfo: dogDetailInfo)
        let interactor: ProfileCreateInteractable =
        ProfileCreateInteractor(
            storeDogInfoUsecase: storeDogInfoUsecase,
            saveProfileImageUseCase: saveProfileImageUsecase
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

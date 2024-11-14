//
//  ProfileCreateRouter.swift
//  SniffMeet
//
//  Created by 윤지성 on 11/14/24.
//
import UIKit

protocol ProfileCreateRoutable {
    static func createProfileCreateModule(dogDetailInfo: DogDetailInfo) -> UIViewController
    func presentMainScreen(from view: ProfileCreateViewable)
}

final class ProfileCreateRouter: ProfileCreateRoutable {
    static func createProfileCreateModule(dogDetailInfo: DogDetailInfo) -> UIViewController {
        let storeDogInfoUsecase: StoreDogInfoUseCase =
        StoreDogInfoUserCaseImpl(localDataManager: LocalDataManager())

        let view: ProfileCreateViewable & UIViewController = ProfileCreateViewController()
        let presenter: ProfileCreatePresentable & DogInfoInteractorOutput
        = ProfileCreatePresenter(dogInfo: dogDetailInfo)
        let interactor: ProfileCreateInteractable =
        ProfileCreateInteractor(usecase: storeDogInfoUsecase)
        let router: ProfileCreateRoutable = ProfileCreateRouter()

        view.presenter = presenter
        presenter.view = view
        presenter.router = router
        presenter.interactor = interactor
        interactor.presenter = presenter

        return view
    }
    
    func presentMainScreen(from view: any ProfileCreateViewable) {
#if DEBUG
        print("여기까지 성공하셨습니다. ")
#endif
    }
}

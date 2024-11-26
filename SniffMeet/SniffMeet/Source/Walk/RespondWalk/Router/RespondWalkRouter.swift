//
//  RespondWalkRouter.swift
//  SniffMeet
//
//  Created by 윤지성 on 11/20/24.
//
import UIKit

protocol RespondWalkRoutable: AnyObject {
    func dismissView(view: any RespondWalkViewable)
}

protocol RespondWalkBuildable {
    static func createRespondtWalkModule(walkNoti: WalkNoti) -> UIViewController
}

final class RespondWalkRouter: RespondWalkRoutable {
    func dismissView(view: any RespondWalkViewable) {
        guard let view = view as? UIViewController else { return }
        view.dismiss(animated: true)
    }
}

extension RespondWalkRouter: RespondWalkBuildable {
    static func createRespondtWalkModule(walkNoti: WalkNoti) -> UIViewController {
        let fetchUseCase: FetchUserInfoUseCase = FetchUserInfoUsecaseImpl()
        let respondUseCase: RespondWalkRequestUseCase = RespondWalkRequestUseCaseImpl()
        let calculateTimeUseCase: CalculateTimeLimitUseCase = CalculateTimeLimitUseCaseImpl()

        let view: RespondWalkViewable & UIViewController = RespondWalkViewController()
        let presenter: RespondWalkPresentable & RespondWalkInteractorOutput =
        RespondWalkPresenter(noti: walkNoti)
        let interactor: RespondWalkInteractable =
        RespondWalkInteractor(fetchUserUseCase: fetchUseCase,
                              respondUseCase: respondUseCase,
                              calculateTimeLimitUseCase: calculateTimeUseCase)
        
        let router: RespondWalkRoutable & RespondWalkBuildable = RespondWalkRouter()

        view.presenter = presenter
        presenter.view = view
        presenter.router = router
        presenter.interactor = interactor
        interactor.presenter = presenter

        return view
    }
}

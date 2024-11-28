//
//  RespondWalkRouter.swift
//  SniffMeet
//
//  Created by 윤지성 on 11/20/24.
//
import CoreLocation
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
        let requestUserInfoUseCase: RequestUserInfoUseCase = RequestUserInfoUsecaseImpl()
        let respondUseCase: RespondWalkRequestUseCase = RespondWalkRequestUseCaseImpl()
        let calculateTimeUseCase: CalculateTimeLimitUseCase = CalculateTimeLimitUseCaseImpl()
        let convertLocationToTextUseCase: ConvertLocationToTextUseCase =
        ConvertLocationToTextUseCaseImpl(geoCoder: CLGeocoder())
        let requestProfileImageUseCase: RequestProfileImageUseCase =
        RequestProfileImageUseCaseImpl()

        let view: RespondWalkViewable & UIViewController = RespondWalkViewController()
        let presenter: RespondWalkPresentable & RespondWalkInteractorOutput =
        RespondWalkPresenter(noti: walkNoti)
        let interactor: RespondWalkInteractable =
        RespondWalkInteractor(
            requestUserInfoUseCase: requestUserInfoUseCase,
            respondUseCase: respondUseCase,
            calculateTimeLimitUseCase: calculateTimeUseCase,
            convertLocationToTextUseCase: convertLocationToTextUseCase,
            requestProfileImageUseCase: requestProfileImageUseCase
        )

        let router: RespondWalkRoutable & RespondWalkBuildable = RespondWalkRouter()

        view.presenter = presenter
        presenter.view = view
        presenter.router = router
        presenter.interactor = interactor
        interactor.presenter = presenter

        return view
    }
}

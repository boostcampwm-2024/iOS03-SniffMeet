//
//  RequestWalkRouter.swift
//  SniffMeet
//
//  Created by 윤지성 on 11/18/24.
//
import UIKit

protocol RequestWalkRoutable: AnyObject {
    func dismissView(view: any RequestWalkViewable)
}

protocol RequestWalkBuildable {
    static func createRequestWalkModule(dogNumber: Int) -> UIViewController
}

final class RequestWalkRouter: RequestWalkRoutable {
    func dismissView(view: any RequestWalkViewable) {
        if let view = view as? UIViewController {
            view.dismiss(animated: true)
        }
    }
}

extension RequestWalkRouter: RequestWalkBuildable {
    /// 서버에 요청할 반려견 request number를 함께 전달
    static func createRequestWalkModule(dogNumber: Int) -> UIViewController {
        let requestWalkInfoUsecase: RequestWalkUseCase = RequestWalkUseCaseImpl()

        let view: RequestWalkViewable & UIViewController = RequestWalkViewController()
        let presenter: RequestWalkPresentable & RequestWalkInteractorOutput = RequestWalkPresenter()
        let interactor: RequestWalkInteractable =
        RequestWalkInteractor(usecase: requestWalkInfoUsecase)
        let router: RequestWalkRoutable & RequestWalkBuildable = RequestWalkRouter()

        view.presenter = presenter
        presenter.view = view
        presenter.router = router
        presenter.interactor = interactor
        interactor.presenter = presenter

        return view
    }
}


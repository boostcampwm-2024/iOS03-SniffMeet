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
    static func createRequestWalkModule(requestNumber: Int) -> UIViewController
}

final class RespondWalkRouter: RespondWalkRoutable {
    func dismissView(view: any RespondWalkViewable) {
        guard let view = view as? UIViewController else { return }
        view.dismiss(animated: true)
    }
}

extension RespondWalkRouter: RespondWalkBuildable {
    static func createRequestWalkModule(requestNumber: Int) -> UIViewController {
        let fetchRequestUseCase: FetchRequestUseCase = FetchRequestUseCaseImpl()
        let respondUseCase: RespondWalkRequestUseCase = RespondWalkRequestUseCaseImpl()

        let view: RespondWalkViewable & UIViewController = RespondWalkViewController()
        let presenter: RespondWalkPresentable & RespondWalkInteractorOutput =
        RespondWalkPresenter(requestNum: requestNumber)
        let interactor: RespondWalkInteractable = RespondWalkInteractor(
            fetchRequestUseCase: fetchRequestUseCase,
            respondUseCase: respondUseCase)
        
        let router: RespondWalkRoutable & RespondWalkBuildable = RespondWalkRouter()

        view.presenter = presenter
        presenter.view = view
        presenter.router = router
        presenter.interactor = interactor
        interactor.presenter = presenter

        return view
    }
    
    
}

//
//  RequestMateRouter.swift
//  SniffMeet
//
//  Created by 배현진 on 11/20/24.
//

import UIKit

protocol RequestMateRoutable: AnyObject {
    var presenter: (any RequestWalkPresentable)? { get set }

    func dismissView(view: any RequestMateViewable)
}

protocol RequestMateBuildable {
    static func createRequestMateModule(profile: DogProfileDTO) -> UIViewController
}

final class RequestMateRouter: RequestMateRoutable {
    weak var presenter: (any RequestWalkPresentable)?

    func dismissView(view: any RequestMateViewable) {
        if let view = view as? UIViewController {
            SNMLogger.log("dismissView")
            view.dismiss(animated: true)
        }
    }
}

extension RequestMateRouter: RequestMateBuildable {
    static func createRequestMateModule(profile: DogProfileDTO) -> UIViewController {
        let respondMateRequestUseCase: RespondMateRequestUseCase = RespondMateRequestUseCaseImpl(
            localDataManager: LocalDataManager(),
            remoteDataManger: SupabaseDatabaseManager.shared)
        let view = RequestMateViewController(profile: profile)
        let presenter: RequestMatePresentable & RequestMateInteractorOutput = RequestMatePresenter()
        let interactor = RequestMateInteractor(respondMateRequestUseCase: respondMateRequestUseCase)
        let router: RequestMateRoutable & RequestMateBuildable = RequestMateRouter()

        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        interactor.presenter = presenter

        return view
    }
}

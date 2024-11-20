//
//  RequestMateRouter.swift
//  SniffMeet
//
//  Created by 배현진 on 11/20/24.
//

import UIKit

protocol RequestMateRoutable: AnyObject {
    func dismissView(view: any RequestMateViewable)
}

protocol RequestMateBuildable {
    static func createRequestMateModule() -> UIViewController
}

final class RequestMateRouter: RequestMateRoutable {
    func dismissView(view: any RequestMateViewable) {
        if let view = view as? UIViewController {
            view.dismiss(animated: true)
        }
    }
}

extension RequestMateRouter: RequestMateBuildable {
    static func createRequestMateModule() -> UIViewController {
        let view = RequestMateViewController()
        let presenter = RequestMatePresenter()
        let interactor = RequestMateInteractor()
        let router: RequestMateRoutable & RequestMateBuildable = RequestMateRouter()

        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        interactor.presenter = presenter

        return view
    }
}
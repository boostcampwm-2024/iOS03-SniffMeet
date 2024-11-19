//
//  RequestMateRouter.swift
//  SniffMeet
//
//  Created by 배현진 on 11/20/24.
//

import UIKit

protocol RequestMateRoutable: AnyObject {
    static func createRequestMateModule() -> UIViewController
}

final class RequestMateRouter: RequestMateRoutable {
    static func createRequestMateModule() -> UIViewController {
        let view = RequestMateViewController()
        let presenter = RequestMatePresenter()
        let interactor = RequestMateInteractor()
        let router = RequestMateRouter()
        
        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        interactor.presenter = presenter

        return view
    }
}

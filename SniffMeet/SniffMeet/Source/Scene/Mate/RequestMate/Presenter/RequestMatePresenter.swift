//
//  RequestMatePresenter.swift
//  SniffMeet
//
//  Created by 배현진 on 11/20/24.
//

import Foundation

protocol RequestMatePresentable: AnyObject {
    var view: RequestMateViewable? { get set }
    var interactor: RequestMateInteractable? { get set }
    var router: RequestMateRoutable? { get set }

    func closeTheView()
    func didTapAcceptButton(id: UUID) async
}

protocol RequestMateInteractorOutput: AnyObject {

}

final class RequestMatePresenter: RequestMatePresentable {
    weak var view: RequestMateViewable?
    var interactor: RequestMateInteractable?
    var router: RequestMateRoutable?

    init(
        view: RequestMateViewable? = nil,
        interactor: RequestMateInteractable? = nil,
        router: RequestMateRoutable? = nil
    ) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }

    func closeTheView() {
        if let view {
            router?.dismissView(view: view)
        }
    }
    func didTapAcceptButton(id: UUID) async {
        SNMLogger.info("id: \(id)")
        await interactor?.saveMateInfo(id: id)
    }
}

extension RequestMatePresenter: RequestMateInteractorOutput {

}

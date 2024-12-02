//
//  RespondMapPresenter.swift
//  SniffMeet
//
//  Created by sole on 11/30/24.
//

import Combine

protocol RespondMapPresentable: AnyObject {
    var view: (any RespondMapViewable)? { get set }
    var router: (any RespondMapRoutable)? { get set }
    var output: (any RespondMapPresenterOutput) { get }

    func didTapDismissButton()
}

final class RespondMapPresenter: RespondMapPresentable {
    var view: (any RespondMapViewable)?
    var router: (any RespondMapRoutable)?
    var output: (any RespondMapPresenterOutput)

    init(
        address: Address,
        view: (any RespondMapViewable)? = nil,
        router: (any RespondMapRoutable)? = nil
    ) {
        self.view = view
        self.router = router
        self.output = DefaultRespondMapPresenterOutput(
            selectedLocation: Just(address)
        )
    }
    func didTapDismissButton() {
        guard let view else { return }
        router?.dismiss(view: view)
    }
}

// MARK: - ResponsdMapPresenterOutput

protocol RespondMapPresenterOutput {
    var selectedLocation: Just<Address> { get }
}

struct DefaultRespondMapPresenterOutput: RespondMapPresenterOutput {
    var selectedLocation: Just<Address>
}

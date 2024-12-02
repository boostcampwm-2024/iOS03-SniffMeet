//
//  RespondMapRouter.swift
//  SniffMeet
//
//  Created by sole on 11/30/24.
//

import UIKit

protocol RespondMapRoutable: Routable, AnyObject {
    var presenter: (any RespondMapPresentable)? { get set }

    func dismiss(view: any RespondMapViewable)
}

final class RespondMapRouter: RespondMapRoutable {
    var presenter: (any RespondMapPresentable)?

    func dismiss(view: any RespondMapViewable) {
        guard let view = view as? UIViewController else { return }
        dismiss(from: view, animated: true)
    }
}

extension RespondMapRouter: RespondMapModuleBuildable {}

// MARK: - RespondMapModuleBuildable

protocol RespondMapModuleBuildable {
    static func createRespondMapView(address: Address) -> UIViewController
}

extension RespondMapModuleBuildable {
    static func createRespondMapView(address: Address) -> UIViewController {
        let view: RespondMapViewController = RespondMapViewController()
        let presenter: any RespondMapPresentable = RespondMapPresenter(address: address)
        let router: any RespondMapRoutable = RespondMapRouter()

        view.presenter = presenter
        presenter.view = view
        presenter.router = router
        router.presenter = presenter

        return view
    }
}

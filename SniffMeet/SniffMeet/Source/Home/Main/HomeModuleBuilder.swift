//
//  HomeModuleBuilder.swift
//  SniffMeet
//
//  Created by Kelly Chui on 11/11/24.
//

import UIKit

enum HomeModuleBuilder {
    static func build() -> UIViewController {
        let view = HomeViewController()
        view.title = "SniffMeet"

        // let router = HomeRouter(view: view)
        // let interactor = HomeInteractor()
        // view.presenter = HomePresenter(view: view, router: router, interactor: interactor)

        return view
    }
}

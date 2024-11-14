//
//  Untitled.swift
//  SniffMeet
//
//  Created by 윤지성 on 11/14/24.
//
import UIKit

protocol ProfileInputRoutable {
    func presentPostCreateScreen(from view: ProfileInputViewable, with dogDetail: DogDetailInfo)
}

protocol ProfileInputBuildable {
    static func createProfileInputModule() -> UIViewController
}

final class ProfileInputRouter: ProfileInputRoutable {
    func presentPostCreateScreen(from view: ProfileInputViewable, with dogDetail: DogDetailInfo) {
        let profileCreateViewController =
        ProfileCreateRouter.createProfileCreateModule(dogDetailInfo: dogDetail)
   
        if let sourceView = view as? UIViewController {
            sourceView.navigationController?.pushViewController(profileCreateViewController,
                                                                animated: true)
        }
    }
}

extension ProfileInputRouter: ProfileInputBuildable {
    static func createProfileInputModule() -> UIViewController {
        let view: ProfileInputViewable & UIViewController = ProfileInputViewController()
        var presenter: ProfileInputPresentable = ProfileInputPresenter()
        let router: ProfileInputRoutable & ProfileInputBuildable = ProfileInputRouter()

        view.presenter = presenter
        presenter.view = view
        presenter.router = router

        return view
    }
}

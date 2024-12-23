//
//  MateListRouter.swift
//  SniffMeet
//
//  Created by Kelly Chui on 11/21/24.
//

import UIKit

protocol MateListRoutable: Routable {
    var presenter: (any MateListPresentable)? { get }
    func presentWalkRequestView(mateListView: any MateListViewable, mate: Mate)
    func showAlert(mateListView: any MateListViewable, title: String, message: String)
    func showMateRequestView(mateListView: any MateListViewable, data: DogProfileDTO)
}

protocol MateListBuildable {
    static func createMateListModule() -> UIViewController
}

final class MateListRouter: MateListRoutable {
    weak var presenter: (any MateListPresentable)?
    func presentWalkRequestView(mateListView: MateListViewable, mate: Mate) {
        guard let mateListView = mateListView as? MateListViewController else { return }
        let requestWalkView = RequestWalkRouter.createRequestWalkModule(mate: mate)
        requestWalkView.modalPresentationStyle = .custom
        requestWalkView.transitioningDelegate = mateListView
        mateListView.present(requestWalkView, animated: true)
    }
    func showAlert(
        mateListView: any MateListViewable,
        title: String,
        message: String
    ) {
        guard let mateListView = mateListView as? UIViewController else { return }
        if let presentedVC = mateListView.presentedViewController as? UIAlertController {
            presentedVC.dismiss(animated: false)
        }

        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        mateListView.present(alertVC, animated: true, completion: nil)
    }
    func showMateRequestView(mateListView: any MateListViewable, data: DogProfileDTO) {
        guard let mateListView = mateListView as? UIViewController else { return }
        let requestMateViewController = RequestMateRouter.createRequestMateModule(profile: data)
        let transitionDelegate = ProfileDropTransitionDelegate()
        requestMateViewController.modalPresentationStyle = .fullScreen
        requestMateViewController.transitioningDelegate = transitionDelegate
        present(from: mateListView, with: requestMateViewController, animated: true)
    }
}

extension MateListRouter: MateListBuildable {
    static func createMateListModule() -> UIViewController {
        let requestMateListUseCase: RequestMateListUseCase = RequestMateListUseCaseImpl(
            remoteDatabaseManager: SupabaseDatabaseManager.shared)
        let requestProfileImageUseCase: RequestProfileImageUseCase = RequestProfileImageUseCaseImpl(
            remoteImageManager: SupabaseStorageManager(
            networkProvider: SNMNetworkProvider()),
            cacheManager: ImageNSCacheManager.shared
        )
        let view: MateListViewable & UIViewController = MateListViewController()
        let presenter: MateListPresentable & MateListInteractorOutput =
        MateListPresenter()
        let interactor: MateListInteractable = MateListInteractor(
            requestMateListUseCase: requestMateListUseCase,
            requestProfileImageUseCase: requestProfileImageUseCase)

        let router: MateListRoutable & MateListBuildable = MateListRouter()

        view.presenter = presenter
        presenter.view = view
        presenter.router = router
        presenter.interactor = interactor
        interactor.presenter = presenter

        return view
    }
}

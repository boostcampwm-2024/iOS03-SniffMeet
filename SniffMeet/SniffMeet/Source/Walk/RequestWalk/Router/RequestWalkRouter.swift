//
//  RequestWalkRouter.swift
//  SniffMeet
//
//  Created by 윤지성 on 11/18/24.
//
import UIKit

protocol RequestWalkRoutable: AnyObject, Routable {
    var presenter: (any RequestWalkPresentable)? { get set }
    
    func dismissView(view: any RequestWalkViewable)
    func showSelectLocationView(from: any RequestWalkViewable)
}

protocol RequestWalkBuildable {
    static func createRequestWalkModule(mate: Mate) -> UIViewController
}

final class RequestWalkRouter: RequestWalkRoutable {
    weak var presenter: (any RequestWalkPresentable)?
    
    func dismissView(view: any RequestWalkViewable) {
        if let view = view as? UIViewController {
            Task{ @MainActor in
                view.dismiss(animated: true)
            }
        }
    }
    func showSelectLocationView(from view: any RequestWalkViewable) {
        guard let view = view as? UIViewController else { return }
        let selectViewController = SelectLocationRouter.build()
        let selectView = selectViewController as? SelectLocationViewable
        selectView?.presenter?.router?.delegate = self

        fullScreen(from: view, with: selectViewController, animated: true)
        // push(from: view, to: selectViewController, animated: true)
    }
}

// MARK: - RequestWalkRouter+RequestWalkBuildable

extension RequestWalkRouter: RequestWalkBuildable {
    /// 서버에 요청할 반려견 mateID를 함께 전달
    static func createRequestWalkModule(mate: Mate) -> UIViewController {
        let requestWalkUseCase: RequestWalkUseCase =
        RequestWalkUseCaseImpl(remoteDatabaseManager: SupabaseDatabaseManager.shared)
        let requestProfileImageUseCase:
        RequestProfileImageUseCase = RequestProfileImageUseCaseImpl(
            remoteImageManager: SupabaseStorageManager(
            networkProvider: SNMNetworkProvider()))
        let loadInfoUseCase: LoadUserInfoUseCase = LoadUserInfoUseCaseImpl(
            dataLoadable: LocalDataManager(),
            imageManageable: SNMFileManager()
            )
        let view: RequestWalkViewable & UIViewController = RequestWalkViewController()
        let presenter: RequestWalkPresentable & RequestWalkInteractorOutput = RequestWalkPresenter()
        let interactor: RequestWalkInteractable = RequestWalkInteractor(
            mate: mate,
            requestWalkUseCase: requestWalkUseCase,
            requestProfileImageUseCase: requestProfileImageUseCase,
            loadUserInfoUseCase: loadInfoUseCase
        )
        let router: RequestWalkRoutable & RequestWalkBuildable = RequestWalkRouter()

        view.presenter = presenter
        presenter.view = view
        presenter.router = router
        presenter.interactor = interactor
        interactor.presenter = presenter
        router.presenter = presenter

        return view
    }
}

//MARK: - RequestWalkRouter+SelectLocationRouterDelegate

extension RequestWalkRouter: SelectLocationRouterDelegate {
    func didDismiss(router: any SelectLocationRoutable, address: Address?) {
        presenter?.didSelectLocation(with: address)
    }
}

//
//  ProcessedWalkRouter.swift
//  SniffMeet
//
//  Created by sole on 12/4/24.
//

import UIKit

protocol ProcessedWalkRoutable: Routable {
    func dismiss(view: any ProcessedWalkViewable)
    func showSelectedLocationMapView(view: any ProcessedWalkViewable, address: Address)
}

final class ProcessedWalkRouter: ProcessedWalkRoutable {
    func dismiss(view: any ProcessedWalkViewable) {
        guard let view = view as? UIViewController else { return }
        dismiss(from: view, animated: true)
    }
    func showSelectedLocationMapView(view: any ProcessedWalkViewable, address: Address) {
        guard let view = view as? UIViewController else { return }
        let selectedLocationView = RespondMapRouter.createRespondMapView(address: address)
        fullScreen(from: view, with: selectedLocationView, animated: true)
    }
}

extension ProcessedWalkRouter: ProcessedWalkModuleBuildable {}

// MARK: - ProcessedWalkModuleBuildable

protocol ProcessedWalkModuleBuildable {
    static func createProcessedWalkView(noti: WalkNoti) -> UIViewController
}

extension ProcessedWalkModuleBuildable {
    static func createProcessedWalkView(noti: WalkNoti) -> UIViewController {
        let view = ProcessedWalkViewController()
        let presenter = ProcessedWalkPresenter(noti: noti)
        let interactor = ProcessedWalkInteractor(
            convertLocationToTextUseCase: ConvertLocationToTextUseCaseImpl(),
            requestUserInfoUseCase: RequestMateInfoUsecaseImpl(),
            requestProfileImageUseCase: RequestProfileImageUseCaseImpl(
                remoteImageManager: SupabaseStorageManager(
                    networkProvider: SNMNetworkProvider()
                ),
                cacheManager: ImageNSCacheManager.shared
            )
        )
        let router = ProcessedWalkRouter()

        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        interactor.presenter = presenter

        return view
    }
}

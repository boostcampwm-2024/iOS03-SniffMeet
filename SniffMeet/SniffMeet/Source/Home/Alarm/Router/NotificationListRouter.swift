//
//  NotificationListRouter.swift
//  SniffMeet
//
//  Created by sole on 12/1/24.
//

import Combine
import UIKit

protocol NotificationListRoutable: AnyObject, Routable {
    func showWalkNotification(view: any NotificationListViewable, walkNoti: WalkNoti)
    func dismiss(view: any NotificationListViewable)
}

final class NotificationListRouter: NSObject, NotificationListRoutable {
    func showWalkNotification(view: any NotificationListViewable, walkNoti: WalkNoti) {
        guard let view = view as? UIViewController else { return }
        let targetView = routeWalkNotification(walkNoti: walkNoti)
        targetView.modalPresentationStyle = .custom
        targetView.transitioningDelegate = self
        present(
            from: UIViewController.topMostViewController ?? view,
            with: targetView,
            animated: true
        )
    }
    func dismiss(view: any NotificationListViewable) {
        guard let view = view as? UIViewController else { return }
        pop(from: view, animated: true)
    }
    private func routeWalkNotification(walkNoti: WalkNoti) -> UIViewController {
        switch walkNoti.category {
        case .walkRequest:
            RespondWalkRouter.createRespondtWalkModule(walkNoti: walkNoti)
        case .walkAccepted, .walkDeclined:
            ProcessedWalkRouter.createProcessedWalkView(noti: walkNoti)
        }
    }
}

// MARK: - NotificationListRouter+UIViewControllerTransitioningDelegate

extension NotificationListRouter: UIViewControllerTransitioningDelegate {
    func presentationController(
        forPresented presented: UIViewController,
        presenting: UIViewController?,
        source: UIViewController
    ) -> UIPresentationController? {
        CardPresentationController(presentedViewController: presented, presenting: presenting)
    }
}

// MARK: - NotificationListModuleBuildable

extension NotificationListRouter: NotificationListModuleBuildable {}

protocol NotificationListModuleBuildable {
    static func createNotificationListModule() -> UIViewController
}

extension NotificationListModuleBuildable {
    static func createNotificationListModule() -> UIViewController {
        let view = NotificationListViewController()
        let presenter = NotificationListPresenter(
            output: DefaultNotificationListPresenterOutput(
                notificationList: CurrentValueSubject([])
            )
        )
        let interactor = NotificationListInteractor(
            requestNotiListUseCase: RequestNotiListUseCaseImpl(
                remoteManager: SupabaseDatabaseManager.shared
            )
        )
        let router = NotificationListRouter()

        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        interactor.presenter = presenter

        return view
    }
}

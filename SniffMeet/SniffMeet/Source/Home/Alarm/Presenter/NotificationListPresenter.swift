//
//  NotificationListPresenter.swift
//  SniffMeet
//
//  Created by sole on 12/1/24.
//

import Combine

protocol NotificationListPresentable: AnyObject {
    var view: (any NotificationListViewable)? { get set }
    var interactor: (any NotificationListInteractable)? { get set }
    var router: (any NotificationListRoutable)? { get set }

    var output: any NotificationListPresenterOutput { get }
    func viewDidLoad()
    func didTapNotificationCell(index: Int)
    func didDeleteNotificationCell(index: Int)
    func didTapDismissButton()
}

protocol NotificationListInteractorOutput: AnyObject {
    func didFetchNotificationList(with: [WalkNoti])
}

final class NotificationListPresenter: NotificationListPresentable {
    weak var view: (any NotificationListViewable)?
    var interactor: (any NotificationListInteractable)?
    var router: (any NotificationListRoutable)?
    var output: any NotificationListPresenterOutput
    
    init(
        view: (any NotificationListViewable)? = nil,
        interactor: (any NotificationListInteractable)? = nil,
        router: (any NotificationListRoutable)? = nil,
        output: any NotificationListPresenterOutput
    ) {
        self.view = view
        self.interactor = interactor
        self.router = router
        self.output = output
    }

    func viewDidLoad() {
        interactor?.fetchNotificationList()
    }
    func didTapNotificationCell(index: Int) {
        guard let view else { return }
        router?.showWalkNotification(view: view, walkNoti: output.notificationList.value[index])
    }
    func didDeleteNotificationCell(index: Int) {
        var notiList = output.notificationList.value
        notiList.remove(at: index)
        output.notificationList.send(notiList)
        // TODO: 서버에도 반영 필요 
    }
    func didTapDismissButton() {
        guard let view else { return }
        router?.dismiss(view: view)
    }
}

// MARK: - NotificationListPresenter+NotficationListInteractorOutput

extension NotificationListPresenter: NotificationListInteractorOutput {
    func didFetchNotificationList(with notificationList: [WalkNoti]) {
        output.notificationList.send(notificationList)
    }
}

// MARK: - NotificationListPresenterOutput

protocol NotificationListPresenterOutput {
    var notificationList: CurrentValueSubject<[WalkNoti], Never> { get }
}

struct DefaultNotificationListPresenterOutput: NotificationListPresenterOutput {
    var notificationList: CurrentValueSubject<[WalkNoti], Never>
}

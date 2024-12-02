//
//  NotificationListInteractor.swift
//  SniffMeet
//
//  Created by sole on 12/1/24.
//

protocol NotificationListInteractable: AnyObject {
    var presenter: (any NotificationListInteractorOutput)? { get set }
    func fetchNotificationList()
}

final class NotificationListInteractor: NotificationListInteractable {
    weak var presenter: (any NotificationListInteractorOutput)?
    private let requestNotiListUseCase: (any RequestNotiListUseCase)

    init(
        presenter: (any NotificationListInteractorOutput)? = nil,
        requestNotiListUseCase: any RequestNotiListUseCase
    ) {
        self.presenter = presenter
        self.requestNotiListUseCase = requestNotiListUseCase
    }

    func fetchNotificationList() {
        Task {
            let notiList = await requestNotiListUseCase.execute()
            presenter?.didFetchNotificationList(with: notiList)
        }
    }
}

//
//  HomePresenter.swift
//  SniffMeet
//
//  Created by sole on 11/18/24.
//

import Combine
import UIKit

protocol HomePresentable: AnyObject {
    var view: (any HomeViewable)? { get set }
    var router: (any HomeRoutable)? { get set }
    var interactor: (any HomeInteractable)? { get set }
    var output: (any HomePresenterOutput) { get }

    func viewDidLoad()
    func notificationBarButtonDidTap()
    func didTapEditButton(userInfo: UserInfo)
    func didTapRequestWalkButton()
}

final class HomePresenter: HomePresentable {
    weak var view: (any HomeViewable)?
    var router: (any HomeRoutable)?
    var interactor: (any HomeInteractable)?
    var output: HomePresenterOutput

    init(
        view: (any HomeViewable)? = nil,
        router: (any HomeRoutable)? = nil,
        interactor: (any HomeInteractable)? = nil,
        output: HomePresenterOutput = DefaultHomePresenterOutput(
            dogInfo: CurrentValueSubject<UserInfo, Never>(UserInfo.example)
        )
    ) {
        self.view = view
        self.router = router
        self.interactor = interactor
        self.output = output
    }

    func viewDidLoad() {
        interactor?.saveDeviceToken()
        do {
            if let dog = try interactor?.loadInfo() {
                output.dogInfo.send(dog)
            }
        } catch {
            SNMLogger.error("이미지 실패?: \(error.localizedDescription)")
            let placeHolderInfo: UserInfo = UserInfo.example
            output.dogInfo.send(placeHolderInfo)
        }
    }

    func notificationBarButtonDidTap() {
        guard let view else { return }
        router?.showNotificationView(homeView: view)
    }

    func didTapEditButton(userInfo: UserInfo) {
        guard let view else { return }
        router?.showProfileEditView(homeView: view, userInfo: userInfo)
    }

    func didTapRequestWalkButton() {
        guard let view else { return }
        router?.transitionToMateListView(homeView: view)
    }
}

// MARK: - HomePresenterOutput

protocol HomePresenterOutput {
    var dogInfo: CurrentValueSubject<UserInfo, Never> { get }
}

struct DefaultHomePresenterOutput: HomePresenterOutput {
    var dogInfo: CurrentValueSubject<UserInfo, Never>
}

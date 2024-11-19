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
    func changeIsPaired(with isPaired: Bool)
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
            dogInfo: PassthroughSubject<Dog, Never>()
        )
    ) {
        self.view = view
        self.router = router
        self.interactor = interactor
        self.output = output
    }

    func viewDidLoad() {
        do {
            if let dog = try interactor?.loadInfo() {
                output.dogInfo.send(dog)
            }
        } catch {
            // TODO: have to fill - alert or placeholder info
            let placeHolderInfo: Dog = Dog(
                name: "SniffMeet",
                age: 0,
                size: .small,
                keywords: [],
                nickname: "",
                profileImage: nil
            )
            output.dogInfo.send(placeHolderInfo)
        }
    }
    func notificationBarButtonDidTap() {
        guard let view else { return }
        router?.showNotificationView(homeView: view)
    }
    func changeIsPaired(with isPaired: Bool) {
        guard let view else { return }
        if isPaired {
            router?.showAlert(
                homeView: view,
                title: "Connected",
                message: "Successfully connected to peer."
            )
        } else {
            router?.showAlert(
                homeView: view,
                title: "Disconnected",
                message: "Connection to peer lost."
            )
        }
    }
}

// MARK: - HomePresenterOutput

protocol HomePresenterOutput {
    var dogInfo: PassthroughSubject<Dog, Never> { get }
}

struct DefaultHomePresenterOutput: HomePresenterOutput {
    var dogInfo: PassthroughSubject<Dog, Never>
}

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
    func profileData(_ data: DogProfileInfo)
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
                message: "성공적으로 연결되었습니다.\n핸드폰끼리 카메라 방향으로 가까이하여 프로필을 교환해보세요."
            )
        } else {
            router?.showAlert(
                homeView: view,
                title: "Disconnected",
                message: "메이트 찾기 실패하였습니다.\n 와이파이와 블루투스가 켜져있는 상태인지 확인해주세요."
            )
        }
    }
    func profileData(_ data: DogProfileInfo) {
        guard let view else { return }
        router?.showMateRequestView(homeView: view, data: data)
    }
}

// MARK: - HomePresenterOutput

protocol HomePresenterOutput {
    var dogInfo: PassthroughSubject<Dog, Never> { get }
}

struct DefaultHomePresenterOutput: HomePresenterOutput {
    var dogInfo: PassthroughSubject<Dog, Never>
}

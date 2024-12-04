//
//  ProcessedWalkPresenter.swift
//  SniffMeet
//
//  Created by sole on 12/4/24.
//

import Combine
import UIKit

protocol ProcessedWalkPresentable: AnyObject {
    var noti: WalkNoti { get }
    var view: (any ProcessedWalkViewable)? { get set }
    var output: (any ProcessedWalkPresenterOutput) { get }

    func viewDidLoad()
    func dismissView()
    func didTapLocationViewButton()
}

protocol ProcessedWalkInteractorOutput: AnyObject {
    func didConvertLocationToText(with: String?)
    func didFetchProfileImage(with: Data?)
    func didFetchUserInfo(senderInfo: UserInfoDTO)
    func didFailToFetchWalkRequest(error: any Error)
}

final class ProcessedWalkPresenter: ProcessedWalkPresentable {
    private(set) var noti: WalkNoti
    weak var view: (any ProcessedWalkViewable)?
    var interactor: (any ProcessedWalkInteractable)?
    var router: (any ProcessedWalkRoutable)?
    var output: (any ProcessedWalkPresenterOutput)

    init(
        noti: WalkNoti,
        view: (any ProcessedWalkViewable)? = nil,
        interactor: (any ProcessedWalkInteractable)? = nil,
        router: (any ProcessedWalkRoutable)? = nil,
        output: any ProcessedWalkPresenterOutput = DefaultProcessedWalkPresenterOutput(
            locationLabel: CurrentValueSubject(nil),
            profileImage: CurrentValueSubject(nil)
        )
    ) {
        self.noti = noti
        self.view = view
        self.output = output
    }

    func viewDidLoad() {
        interactor?.fetchSenderInfo(userId: noti.senderId)
        interactor?.convertLocationToText(
            latitude: noti.latitude,
            longtitude: noti.longtitude
        )
    }
    func dismissView() {
        guard let view else { return }
        router?.dismiss(view: view)
    }
    func didTapLocationViewButton() {
        guard let view else { return }
        let address: Address = Address(
            longtitude: noti.longtitude,
            latitude: noti.latitude
        )
        router?.showSelectedLocationMapView(view: view, address: address)
    }
}

// MARK: - ProcessedWalkPresenter+ProcessedWalkInteractorOutput

extension ProcessedWalkPresenter: ProcessedWalkInteractorOutput {
    func didConvertLocationToText(with: String?) {
        output.locationLabel.send(with)
    }
    func didFetchProfileImage(with: Data?) {
        guard let imageData = with else { return }
        output.profileImage.send(UIImage(data: imageData))
    }
    func didFetchUserInfo(senderInfo: UserInfoDTO) {
        let walkRequest = WalkRequestDetail(
            mate: senderInfo.toEntity(),
            address: Address(
                longtitude: noti.longtitude,
                latitude: noti.latitude
            ),
            message: noti.message
        )
        let isAccepted = (noti.category == .walkAccepted)
        Task { @MainActor [weak self] in
            self?.view?.showRequestDetail(isAccepted: isAccepted, request: walkRequest)
        }
    }
    func didFailToFetchWalkRequest(error: any Error) {
        // TODO: have to fill 
    }
}

// MARK: - ProcessedWalkPresenterOutput

protocol ProcessedWalkPresenterOutput {
    var locationLabel: CurrentValueSubject<String?, Never> { get }
    var profileImage: CurrentValueSubject<UIImage?, Never> { get }
}

struct DefaultProcessedWalkPresenterOutput: ProcessedWalkPresenterOutput {
    let locationLabel: CurrentValueSubject<String?, Never>
    let profileImage: CurrentValueSubject<UIImage?, Never>
}

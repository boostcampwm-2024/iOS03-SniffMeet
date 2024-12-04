//
//  MateListPresenter.swift
//  SniffMeet
//
//  Created by Kelly Chui on 11/21/24.
//

import Combine
import Foundation

protocol MateListPresentable: AnyObject {
    var view: (any MateListViewable)? { get set }
    var router: (any MateListRoutable)? { get set }
    var interactor: (any MateListInteractable)? { get set }
    var output: any MateListPresenterOutput { get }
    
    func viewWillAppear()
    func didTableViewCellLoad(index: Int, imageName: String?)
    func didTabAccessoryButton(mate: Mate)
    func changeIsPaired(with isPaired: Bool)
    func profileData(_ data: DogProfileDTO)
}

protocol MateListInteractorOutput: AnyObject {
    func didFetchMateList(mateList: [Mate])
    func didFetchProfileImage(index: Int, imageData: Data?)
}

final class MateListPresenter: MateListPresentable {
    
    weak var view: (any MateListViewable)?
    var interactor: (any MateListInteractable)?
    var router: (any MateListRoutable)?
    let output: any MateListPresenterOutput

    init(
        view: (any MateListViewable)? = nil,
        output: any MateListPresenterOutput = DefaultMateListPresenterOutput()
    )
    {
        self.view = view
        self.output = output
    }

    func viewWillAppear() {
        guard let userID = SessionManager.shared.session?.user?.userID else {
            SNMLogger.error("세션 없음")
            // FIXME: 세션 없음 - 앱 라우터에서 로그인으로 튕기게 하거나 해야할듯
            return
        }
        interactor?.requestMateList(userID: userID)
        SNMLogger.info("메이트 리스트 호출")
    }

    func didTableViewCellLoad(index: Int, imageName: String?) {
        interactor?.requestProfileImage(index: index, imageName: imageName)
    }

    func didTabAccessoryButton(mate: Mate) {
        guard let view else { return }
        router?.presentWalkRequestView(mateListView: view, mate: mate)
    }

    func changeIsPaired(with isPaired: Bool) {
        guard let view else { return }
        if isPaired {
            router?.showAlert(
                mateListView: view,
                title: "Connected",
                message: "성공적으로 연결되었습니다.\n핸드폰끼리 카메라 방향으로 가까이하여 프로필을 교환해보세요."
            )
        } else {
            router?.showAlert(
                mateListView: view,
                title: "Disconnected",
                message: "메이트 찾기 실패하였습니다.\n 와이파이와 블루투스가 켜져있는 상태인지 확인해주세요."
            )
        }
    }

    func profileData(_ data: DogProfileDTO) {
        guard let view else { return }
        router?.showMateRequestView(mateListView: view, data: data)
    }
}

extension MateListPresenter: MateListInteractorOutput {
    func didFetchMateList(mateList: [Mate]) {
        output.mates.send(mateList)
    }

    func didFetchProfileImage(index: Int, imageData: Data?) {
        guard let imageData else { return }
        output.profileImageData.send((index, imageData))
    }
}

// MARK: - MateListPresenterOutput

protocol MateListPresenterOutput {
    var mates: CurrentValueSubject<[Mate], Never> { get }
    var profileImageData: PassthroughSubject<(Int, Data?), Never> { get }
}

struct DefaultMateListPresenterOutput: MateListPresenterOutput {
    var mates = CurrentValueSubject<[Mate], Never>([])
    var profileImageData = PassthroughSubject<(Int, Data?), Never>()
}

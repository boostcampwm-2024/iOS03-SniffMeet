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

    func viewDidLoad()
    func didTableViewCellLoad(index: Int, urlString: String?)
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

    func viewDidLoad() {
        guard let userID = SessionManager.shared.session?.user?.userID else {
            SNMLogger.error("세션 없음")
            return // FIXME: 세션 없음 예외 처리 -> 앱 라우터에서 로그인으로 튕기게 하거나 해야할듯
        }
        interactor?.requestMateList(userID: userID)
    }

    func didTableViewCellLoad(index: Int, urlString: String?) {
        interactor?.requestProfileImage(index: index, urlString: urlString)
    }
}

extension MateListPresenter: MateListInteractorOutput {
    func didFetchMateList(mateList: [Mate]) {
        output.mates.send(mateList)
    }

    func didFetchProfileImage(index: Int, imageData: Data?) {
        guard let imageData else { return } // 무한 루프 방지
        output.profileImageData.send((index, imageData))
    }
}

// MARK: - MateListPresenterOutput

protocol MateListPresenterOutput {
    var mates: PassthroughSubject<[Mate], Never> { get }
    var profileImageData: PassthroughSubject<(Int, Data?), Never> { get }
}

struct DefaultMateListPresenterOutput: MateListPresenterOutput {
    var mates = PassthroughSubject<[Mate], Never>()
    var profileImageData = PassthroughSubject<(Int, Data?), Never>()
}
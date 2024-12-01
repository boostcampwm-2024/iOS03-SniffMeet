//
//  ProfileEditPresenter.swift
//  SniffMeet
//
//  Created by Kelly Chui on 11/28/24.
//

import Combine
import UIKit

protocol ProfileEditPresentable: AnyObject {
    var userInfo: UserInfo { get set }
    var view: (any ProfileEditViewable)? { get set }
    var router: (any ProfileEditRoutable)? { get set }
    var interactor: (any ProfileEditInteractable)? { get set }
    var output: any ProfileEditPresenterOutput { get }

    func viewDidLoad()
    func didTapCompleteButton(
        name: String?,
        age: String?,
        keywords: [String]?,
        size: Int?,
        profileImage: UIImage?
    )
}

final class ProfileEditPresenter: ProfileEditPresentable {
    var userInfo: UserInfo
    weak var view: (any ProfileEditViewable)?
    var router: (any ProfileEditRoutable)?
    var interactor: (any ProfileEditInteractable)?
    let output: any ProfileEditPresenterOutput

    init(
        userInfo: UserInfo,
        view: (any ProfileEditViewable)? = nil,
        router: (any ProfileEditRoutable)? = nil,
        interactor: ProfileEditInteractor? = nil,
        output: ProfileEditPresenterOutput = DefaultProfileEditPresenterOutput(
            userInfo: PassthroughSubject<UserInfo, Never>()
        )
    )
    {
        self.userInfo = userInfo
        self.view = view
        self.router = router
        self.interactor = interactor
        self.output = output
    }

    func viewDidLoad() {
        do {
            if let userInfo = try interactor?.requestUserInfo() {
                didFetchUserInfo(userInfo: userInfo)
            }
        } catch {

        }
    }

    func didTapCompleteButton(
        name: String?,
        age: String?,
        keywords: [String]?,
        size: Int?,
        profileImage: UIImage?
    ) {
        guard let profileImage else { return }
        let pngData = convertImageToPNGData(image: profileImage)
        let jpgData = convertImageToJPGData(image: profileImage)
        interactor?.updateUserInfo(name: name,
                                   age: UInt8(age ?? "0"),
                                   size: String(size ?? 0),
                                   keywords: keywords,
                                   profileImageData: (pngData, jpgData)
        )
    }

    private func convertImageToPNGData(image: UIImage) -> Data? {
        image.pngData()
    }

    private func convertImageToJPGData(image: UIImage) -> Data? {
        image.jpegData(compressionQuality: 0.7)
    }
}

// MARK: - ProfileEditPresenter+ProfileEditInteractorOutput

protocol ProfileEditInteractorOutput: AnyObject {
    func didFetchUserInfo(userInfo: UserInfo)
    func didSaveUserInfo()
}

extension ProfileEditPresenter: ProfileEditInteractorOutput {
    func didFetchUserInfo(userInfo: UserInfo) {
        output.userInfo.send(userInfo)
    }
    func didSaveUserInfo() {
        guard let view else { return }
        router?.presentMainScreen(from: view)
    }
}

// MARK: - ProfileEditPresenterOutput

protocol ProfileEditPresenterOutput {
    var userInfo: PassthroughSubject<UserInfo, Never> { get }
}

struct DefaultProfileEditPresenterOutput: ProfileEditPresenterOutput {
    var userInfo: PassthroughSubject<UserInfo, Never>
}

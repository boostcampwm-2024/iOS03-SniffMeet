//
//  ProfileEditPresenter.swift
//  SniffMeet
//
//  Created by Kelly Chui on 11/28/24.
//

import Combine
import UIKit

protocol ProfileEditPresentable: AnyObject {
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
    weak var view: (any ProfileEditViewable)?
    var interactor: (any ProfileEditInteractable)?
    var router: (any ProfileEditRoutable)?
    let output: any ProfileEditPresenterOutput

    init(
        view: (any ProfileEditViewable)? = nil,
        output: any ProfileEditPresenterOutput = DefaultProfileEditPresenterOutput()
    )
    {
        self.view = view
        self.output = output
    }

    func viewDidLoad() {
        interactor?.requestUserInfo()
        interactor?.requestUserProfileImage()
    }

    func didTapCompleteButton(
        name: String?,
        age: String?,
        keywords: [String]?,
        size: Int?,
        profileImage: UIImage?
    ) {
        updateUserName(to: name)
        updateUserAge(to: age)
        updateUserKeywords(to: keywords)
        updateUserSize(to: size)
        updateUserProfileImage(to: profileImage)
    }

    private func updateUserName(to name: String?) {
        guard let name else { return }
        interactor?.updateUserName(name: name)
    }

    private func updateUserAge(to age: String?) {
        guard let age = age, let ageInteger = UInt8(age) else { return }
        interactor?.updateUserAge(age: ageInteger)
    }

    private func updateUserKeywords(to keywords: [String]?) {
        guard let keywords else { return }
        interactor?.updateUserKeywords(keywords: keywords)
    }

    private func updateUserSize(to size: Int?) {
        guard let size else { return }
        var sizeString = String()
        switch size {
        case 0: sizeString = "소형"
        case 1: sizeString = "중형"
        case 2: sizeString = "대형"
        default: break
        }
        interactor?.updateUserSize(size: sizeString)
    }

    private func updateUserProfileImage(to profileImage: UIImage?) {
        guard let profileImage else { return }
        let pngData = convertImageToPNGData(image: profileImage)
        let jpgData = convertImageToJPGData(image: profileImage)
        interactor?.updateUserProfileImage(profileImageData: (pngData, jpgData))
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
    func didFetchUserInfo(userInfo: UserInfoDTO)
    func didFetchProfileImage(imageData: Data?)
}

extension ProfileEditPresenter: ProfileEditInteractorOutput {
    func didFetchUserInfo(userInfo: UserInfoDTO) {
        output.userInfo.send(userInfo)
    }

    func didFetchProfileImage(imageData: Data?) {
        guard let imageData else { return }
        output.profileImageData.send(imageData)
    }
}

// MARK: - ProfileEditPresenterOutput

protocol ProfileEditPresenterOutput {
    var userInfo: CurrentValueSubject<UserInfoDTO?, Never> { get }
    var profileImageData: PassthroughSubject<Data?, Never> { get }
}

struct DefaultProfileEditPresenterOutput: ProfileEditPresenterOutput {
    let userInfo = CurrentValueSubject<UserInfoDTO?, Never>(nil)
    let profileImageData = PassthroughSubject<Data?, Never>()
}

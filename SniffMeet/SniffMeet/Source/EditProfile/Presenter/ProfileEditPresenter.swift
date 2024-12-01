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

    func didTapCompleteButton(userInfo: UserInfo, profileImage: UIImage?) {
        interactor?.updateUserInfo(userInfo: userInfo)
        guard let profileImage else { return }
        let pngData = convertImageToPNGData(image: profileImage)
        let jpgData = convertImageToJPGData(image: profileImage)
        interactor?.updateUserProfileImage(profileImageData: (pngData, jpgData))
    }

    private func convertImageToPNGData(image: UIImage) -> Data? {
        return image.pngData()
    }
    
    private func convertImageToJPGData(image: UIImage) -> Data? {
        return image.jpegData(compressionQuality: 0.7)
    }
}

protocol ProfileEditInteractorOutput: AnyObject {
    
}

// MARK: - ProfileEditPresenterOutput

protocol ProfileEditPresenterOutput {

}

struct DefaultProfileEditPresenterOutput: ProfileEditPresenterOutput {

}

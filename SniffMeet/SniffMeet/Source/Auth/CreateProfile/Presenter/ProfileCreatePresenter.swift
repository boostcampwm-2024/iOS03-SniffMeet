//
//  ProfileSetupPresenter.swift
//  SniffMeet
//
//  Created by 윤지성 on 11/14/24.
//
import Foundation
import UIKit

protocol ProfileCreatePresentable : AnyObject{
    var dogInfo: DogInfo { get set }
    var view: ProfileCreateViewable? { get set }
    var interactor: ProfileCreateInteractable? { get set }
    var router: ProfileCreateRoutable? { get set }
    
    func didTapSubmitButton(nickname: String, image: UIImage?)
}

protocol DogInfoInteractorOutput: AnyObject {
    func didSaveUserInfo()
    func didFailToSaveUserInfo(error: Error)
}


final class ProfileCreatePresenter: ProfileCreatePresentable {
    var dogInfo: DogInfo
    weak var view: ProfileCreateViewable?
    var interactor: ProfileCreateInteractable?
    var router: ProfileCreateRoutable?
    
    init(dogInfo: DogInfo,
         view: ProfileCreateViewable? = nil,
         interactor: ProfileCreateInteractable? = nil,
         router: ProfileCreateRoutable? = nil)
    {
        self.dogInfo = dogInfo
        self.view = view
        self.interactor = interactor
        self.router = router
    }

    func didTapSubmitButton(nickname: String, image: UIImage?) {
        let imageData = interactor?.convertImageToData(image: image)
        let userInfo = UserInfo(
            name: dogInfo.name,
            age: dogInfo.age,
            sex: dogInfo.sex,
            sexUponIntake: dogInfo.sexUponIntake,
            size: dogInfo.size,
            keywords: dogInfo.keywords,
            nickname: nickname,
            profileImage: nil
        )
        // TODO: SubmitButton disable 필요
        interactor?.signInWithProfileData(dogInfo: userInfo, imageData: imageData)
    }
}

extension ProfileCreatePresenter: DogInfoInteractorOutput {
    func didSaveUserInfo() {
        // TODO: submit button enable
        guard let view else { return }
        router?.presentMainScreen(from: view)
    }
    
    func didFailToSaveUserInfo(error: any Error) {
        // TODO: -  alert 올리는데 어떻게 올릴지 정하기
        // TODO: submit button enable
    }
}

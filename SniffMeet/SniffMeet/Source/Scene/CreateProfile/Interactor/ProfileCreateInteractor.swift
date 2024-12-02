//
//  ProfileCreateInteractable.swift
//  SniffMeet
//
//  Created by 윤지성 on 11/14/24.
//

import UIKit

protocol ProfileCreateInteractable: AnyObject {
    var presenter: DogInfoInteractorOutput? { get set }
    var saveUserInfoUseCase: SaveUserInfoUseCase { get set }
    var saveProfileImageUseCase: SaveProfileImageUseCase { get }

    func signInWithProfileData(dogInfo: UserInfo, imageData: (png: Data?, jpg: Data?))
    func convertImageToPNGData(image: UIImage?) -> Data?
    func convertImageToJPGData(image: UIImage?) -> Data?
}

final class ProfileCreateInteractor: ProfileCreateInteractable {
    weak var presenter: DogInfoInteractorOutput?
    var saveUserInfoUseCase: SaveUserInfoUseCase
    var saveProfileImageUseCase: SaveProfileImageUseCase
    var saveUserInfoRemoteUseCase: CreateAccountUseCase

    init(
        presenter: DogInfoInteractorOutput? = nil,
        saveUserInfoUseCase: SaveUserInfoUseCase,
        saveProfileImageUseCase: SaveProfileImageUseCase,
        saveUserInfoRemoteUseCase: CreateAccountUseCase
    ) {
        self.presenter = presenter
        self.saveUserInfoUseCase = saveUserInfoUseCase
        self.saveProfileImageUseCase = saveProfileImageUseCase
        self.saveUserInfoRemoteUseCase = saveUserInfoRemoteUseCase
    }

    func signInWithProfileData(dogInfo: UserInfo, imageData: (png: Data?, jpg: Data?)) {
        Task {
            do {
                await SupabaseAuthManager.shared.signInAnonymously()
                try saveUserInfoUseCase.execute(dog: UserInfo(
                    name: dogInfo.name,
                    age: dogInfo.age,
                    sex: dogInfo.sex,
                    sexUponIntake: dogInfo.sexUponIntake,
                    size: dogInfo.size,
                    keywords: dogInfo.keywords,
                    nickname: dogInfo.nickname,
                    profileImage: imageData.png)
                )
                var fileName: String? = nil
                if let jpgData = imageData.jpg {
                    fileName = try await saveProfileImageUseCase.execute(
                        imageData: jpgData
                    )
                }
                guard let userID = SessionManager.shared.session?.user?.userID else {
                    return
                }
                await saveUserInfoRemoteUseCase.execute(
                    info: UserInfoDTO(
                        id: userID,
                        dogName: dogInfo.name,
                        age: dogInfo.age,
                        sex: dogInfo.sex,
                        sexUponIntake: dogInfo.sexUponIntake,
                        size: dogInfo.size,
                        keywords: dogInfo.keywords,
                        nickname: dogInfo.nickname,
                        profileImageURL: fileName
                    )
                )
                presenter?.didSaveUserInfo()
            } catch {
                presenter?.didFailToSaveUserInfo(error: error)
            }
        }
    }
    func convertImageToPNGData(image: UIImage?) -> Data? {
        guard let image else { return nil }
        return image.pngData()
    }
    func convertImageToJPGData(image: UIImage?) -> Data? {
        guard let image else { return nil }
        return image.jpegData(compressionQuality: 0.8)
    }
}

//
//  ProfileCreateInteractable.swift
//  SniffMeet
//
//  Created by 윤지성 on 11/14/24.
//

import Foundation
import UIKit

protocol ProfileCreateInteractable: AnyObject {
    var presenter: DogInfoInteractorOutput? { get set }
    var storeDogInfoUseCase: StoreDogInfoUseCase { get set }
    var saveProfileImageUseCase: SaveProfileImageUseCase { get }

    func signInWithProfileData(dogInfo: Dog)
    func convertImageToData(image: UIImage?) -> Data?
}

final class ProfileCreateInteractor: ProfileCreateInteractable {
    weak var presenter: DogInfoInteractorOutput?
    var storeDogInfoUseCase: StoreDogInfoUseCase
    var saveProfileImageUseCase: SaveProfileImageUseCase

    init(
        presenter: DogInfoInteractorOutput? = nil,
        storeDogInfoUsecase: StoreDogInfoUseCase,
        saveProfileImageUseCase: SaveProfileImageUseCase
    ) {
        self.presenter = presenter
        self.storeDogInfoUseCase = storeDogInfoUsecase
        self.saveProfileImageUseCase = saveProfileImageUseCase
    }

    func signInWithProfileData(dogInfo: Dog) {
        Task {
            do {
                await SupabaseAuthManager.shared.signInAnonymously()
                try storeDogInfoUseCase.execute(dog: dogInfo)
                if let profileImageData = dogInfo.profileImage {
                    _ = try await saveProfileImageUseCase.execute(imageData: profileImageData)
                }
                presenter?.didSaveDogInfo()
            } catch {
                presenter?.didFailToSaveDogInfo(error: error)
            }
        }
    }
    func convertImageToData(image: UIImage?) -> Data? {
        guard let image else { return nil }
        return image.pngData()
    }
}

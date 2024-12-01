//
//  ProfileEditInteractor.swift
//  SniffMeet
//
//  Created by Kelly Chui on 12/1/24.
//

import Foundation

protocol ProfileEditInteractable: AnyObject {
    var presenter: (any ProfileEditInteractorOutput)? { get set }
    var saveUserInfoUseCase: SaveUserInfoUseCase { get set }
    var updateUserInfoRemoteUseCase: UpdateUserInfoUseCase { get set }
    var saveProfileImageUseCase: SaveProfileImageUseCase { get set }

    func requestUserInfo() throws -> UserInfo
    func updateUserInfo(name: String?,
                        age: UInt8?,
                        size: String,
                        keywords: [String]?,
                        profileImageData: (Data?, Data?)
    )
}

final class ProfileEditInteractor: ProfileEditInteractable {
    weak var presenter: (any ProfileEditInteractorOutput)?
    var saveUserInfoUseCase: SaveUserInfoUseCase
    var updateUserInfoRemoteUseCase: UpdateUserInfoUseCase
    var saveProfileImageUseCase: SaveProfileImageUseCase
    private let loadUserInfoUseCase: LoadUserInfoUseCase

    init(
        presenter: (any ProfileEditInteractorOutput)? = nil,
        saveUserInfoUseCase: SaveUserInfoUseCase,
        updateUserInfoRemoteUseCase: UpdateUserInfoUseCase,
        saveProfileImageUseCase: SaveProfileImageUseCase,
        loadUserInfoUseCase: LoadUserInfoUseCase
    ) {
        self.presenter = presenter
        self.saveUserInfoUseCase = saveUserInfoUseCase
        self.updateUserInfoRemoteUseCase = updateUserInfoRemoteUseCase
        self.saveProfileImageUseCase = saveProfileImageUseCase
        self.loadUserInfoUseCase = loadUserInfoUseCase
    }
    func requestUserInfo() throws -> UserInfo {
        try loadUserInfoUseCase.execute()
    }
    func updateUserInfo(name: String?,
                        age: UInt8?,
                        size: String,
                        keywords: [String]?,
                        profileImageData: (Data?, Data?))
    {
        Task {
            do {
                let convertedKeywords: [Keyword]? = keywords?.compactMap { Keyword(rawValue: $0) }
                try saveUserInfoUseCase.execute(dog: UserInfo(name: name ?? "",
                                                              age: age ?? 0,
                                                              sex: Sex.female,
                                                              sexUponIntake: true,
                                                              size: Size(rawValue: size) ?? .small,
                                                              keywords: convertedKeywords ?? [],
                                                              nickname: "",
                                                              profileImage: profileImageData.0))
                var fileName: String? = nil
                if let jpgData = profileImageData.1 {
                    fileName = try await saveProfileImageUseCase.execute(
                        imageData: jpgData
                    )
                }
                guard let userID = SessionManager.shared.session?.user?.userID else {
                    return
                }
                await updateUserInfoRemoteUseCase.execute(
                    info: UserInfoDTO(
                        id: userID,
                        dogName: name ?? "",
                        age: age ?? 0,
                        sex: Sex.female,
                        sexUponIntake: true,
                        size: Size(rawValue: size) ?? .small,
                        keywords: convertedKeywords ?? [],
                        nickname: "",
                        profileImageURL: fileName
                    )
                )
                presenter?.didSaveUserInfo()
            } catch {
                SNMLogger.error("데이터 갱신 안됨: \(error)")
            }
        }
    }
}

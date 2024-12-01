//
//  ProfileEditInteractor.swift
//  SniffMeet
//
//  Created by Kelly Chui on 12/1/24.
//

import Foundation

protocol ProfileEditInteractable: AnyObject {
    var presenter: ProfileEditInteractorOutput? { get set }

    func requestUserInfo()
    func requestUserProfileImage()
    func updateUserName(name: String?)
    func updateUserAge(age: UInt8?)
    func updateUserSize(size: String)
    func updateUserKeywords(keywords: [String]?)
    func updateUserProfileImage(profileImageData: (Data?, Data?))
}

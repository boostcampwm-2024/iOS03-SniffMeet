//
//  ProfileEditInteractor.swift
//  SniffMeet
//
//  Created by Kelly Chui on 12/1/24.
//

import Foundation

protocol ProfileEditInteractable: AnyObject {
    func requestUserInfo()
    func requestUserProfileImage()
    func updateUserInfo(userInfo: UserInfo)
    func updateUserProfileImage(profileImageData: (Data?, Data?))
}

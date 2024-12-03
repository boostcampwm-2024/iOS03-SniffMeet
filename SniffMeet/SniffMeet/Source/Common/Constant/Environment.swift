//
//  Environment.swift
//  SniffMeet
//
//  Created by sole on 11/25/24.
//

enum Environment {
    enum UserDefaultsKey {
        static let profileImage: String = "profileImage"
        static let dogInfo: String = "dogInfo"
        static let expiresAt: String = "expiresAt"
        static let mateList: String = "mateList"
        static let isFirstLaunch: String = "isFirstLaunch"
    }

    enum KeychainKey {
        static let accessToken: String = "accessToken"
        static let refreshToken: String = "refreshToken"
        static let deviceToken: String = "deviceToken"
    }
    
    enum FileManagerKey {
        static let profileImage: String = "profile"
    }
    
    enum SupabaseTableName {
        static let userInfo = "user_info"
        static let notification = "notification"
        static let notificationList = "notification_list"
        static let matelist = "mate_list"
        static let matelistFunction = "rpc/get_user_info_from_mate_list"
        static let notificationListFunction = "rpc/notification_list"
        static let walkRequest = "walk_request"
    }
}

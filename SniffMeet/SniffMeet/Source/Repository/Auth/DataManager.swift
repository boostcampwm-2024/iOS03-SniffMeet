//
//  DataManager.swift
//  SniffMeet
//
//  Created by 윤지성 on 11/14/24.
//

import Foundation

protocol DataStorable {
    func storeData(data: Encodable) throws
}

// TODO: -  dataManager를 주입받을 수 있도록 수정 예정
final class LocalDataManager: DataStorable {
    private let dataManager = UserDefaultsManager(userDefaults: UserDefaults(suiteName: "demo")!,
                                                  jsonEncoder: JSONEncoder(),
                                                  jsonDecoder: JSONDecoder())
    func storeData(data: any Encodable) throws {
        try dataManager.set(value: data, forKey: UserDefaultKey.dogInfo)
    }
}

extension LocalDataManager {
    private enum UserDefaultKey {
        static let dogInfo: String = "dogInfo"
    }
}

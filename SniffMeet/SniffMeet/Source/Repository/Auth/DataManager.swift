//
//  DataManager.swift
//  SniffMeet
//
//  Created by 윤지성 on 11/14/24.
//

import Foundation

protocol DataStorable {
    func storeData(data: Encodable, key: String) throws
}

protocol DataLoadable {
    func loadData<T>(forKey: String, type: T.Type) throws -> T where T: Decodable
}

// TODO: -  dataManager를 주입받을 수 있도록 수정 예정
final class LocalDataManager: DataStorable {
    private let dataManager = UserDefaultsManager(userDefaults: UserDefaults(suiteName: "demo")!,
                                                  jsonEncoder: JSONEncoder(),
                                                  jsonDecoder: JSONDecoder())
    func storeData(data: any Encodable, key: String) throws {
        try dataManager.set(value: data, forKey: key)
    }
}

// MARK: - LocalDataManager+DataLoadable

extension LocalDataManager: DataLoadable {
    func loadData<T>(forKey: String, type: T.Type) throws -> T where T: Decodable {
        try dataManager.get(forKey: forKey, type: type)
    }
}

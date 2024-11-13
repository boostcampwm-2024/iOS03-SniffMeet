//
//  UserDefaultsManager.swift
//  SniffMeet
//
//  Created by sole on 11/7/24.
//

import Foundation

protocol UserDefaultsManagable {
    func get<T>(forKey: String, type: T.Type) throws -> T where T: Decodable
    func set<T>(value: T, forKey: String) throws where T: Encodable
    func delete(forKey: String) throws
}

/// UserDefaults를 관리하는 클래스입니다.
/// 생성 시 userDefaults 파라미터에 아무것도 주입하지 않으면 standard를 기본으로 사용합니다.
final class UserDefaultsManager: UserDefaultsManagable {
    private let userDefaults: UserDefaults
    private let jsonEncoder: JSONEncoder
    private let jsonDecoder: JSONDecoder

    init(
        userDefaults: UserDefaults = .standard,
        jsonEncoder: JSONEncoder,
        jsonDecoder: JSONDecoder
    ) {
        self.userDefaults = userDefaults
        self.jsonEncoder = jsonEncoder
        self.jsonDecoder = jsonDecoder
    }

    /// 값이 UserDefaults에 없는 경우 nil을 반환합니다.
    func get<T>(forKey key: String, type: T.Type) throws -> T where T: Decodable {
        guard let data = userDefaults.data(forKey: key)
        else {
            throw UserDefaultsError.notFound
        }

        do {
            let decodedValue = try jsonDecoder.decode(type, from: data)
            return decodedValue
        } catch {
            throw UserDefaultsError.decodingError
        }
    }
    func set<T: Encodable>(value: T, forKey: String) throws where T: Encodable {
        do {
            let encodedData = try jsonEncoder.encode(value)
            userDefaults.setValue(encodedData, forKey: forKey)
        } catch {
            throw UserDefaultsError.encodingError
        }
    }
    func delete(forKey key: String) throws {
        if userDefaults.data(forKey: key) != nil {
            userDefaults.removeObject(forKey: key)
        } else {
            throw UserDefaultsError.noDeleteObject
        }
    }
}

// MARK: - UserDefaultsManager+Singleton instance

extension UserDefaultsManager {
    /// UserDefaultsManager 싱글톤 인스턴스입니다. 내부적으로 UserDefaults.standard를 사용합니다.
    static let shared: UserDefaultsManager = UserDefaultsManager(
        userDefaults: .standard,
        jsonEncoder: JSONEncoder(),
        jsonDecoder: JSONDecoder()
    )
}

// MARK: - UserDefaultsError

enum UserDefaultsError: LocalizedError {
    case notFound
    case encodingError
    case decodingError
    case noDeleteObject

    var errorDescription: String? {
        switch self {
        case .notFound: "key에 대한 값을 찾을 수 없습니다."
        case .encodingError: "인코딩 에러"
        case .decodingError: "디코딩 에러"
        case .noDeleteObject: "삭제할 대상을 찾을 수 없습니다."
        }
    }
}

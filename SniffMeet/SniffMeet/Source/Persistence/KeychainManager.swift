//
//  KeychainManager.swift
//  SniffMeet
//
//  Created by sole on 11/7/24.
//

import Foundation

protocol KeychainManagable {
    func get(forKey: String) throws -> String
    func set(value: String, forKey: String) throws
    func delete(forKey: String) throws
}

/// Keychain에 접근할 수 있는 싱글톤 인스턴스입니다.
/// key, value 타입은 String으로 한정합니다.
final class KeychainManager: KeychainManagable {
    private init() {}

    func get(forKey key: String) throws -> String {
        let query: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecMatchLimit: kSecMatchLimitOne,
            kSecAttrAccount: key,
            kSecReturnAttributes: true,
            kSecReturnData: true
        ]
        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        guard let existingItem = item as? [CFString: Any],
              let valueData = existingItem[kSecValueData] as? Data,
              let value = String(data: valueData, encoding: .utf8)
        else {
            throw KeychainError(rawValue: status) ?? .decodingError
        }
        return value
    }
    /// Keychain에 등록되지 않은 값의 경우 값을 생성합니다.
    /// 이미 Keychain에 등록된 값의 경우 값을 업데이트합니다.
    func set(value: String, forKey key: String) throws {
        if (try? get(forKey: key)) != nil {
            try update(value: value, forKey: key)
        } else {
            try create(key: key, value: value)
        }
    }
    func delete(forKey key: String) throws {
        let query: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key
        ]
        let status = SecItemDelete(query as CFDictionary)
        if let error = KeychainError(rawValue: status) {
            throw error
        }
    }
    private func create(key: String, value: String) throws {
        let query: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key,
            kSecValueData: Data(value.utf8)
        ]
        let status = SecItemAdd(query as CFDictionary, nil)
        if let error = KeychainError(rawValue: status) {
            throw error
        }
    }
    private func update(value: String, forKey key: String) throws {
        let searchQuery: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key
        ]
        let updateQuery: [CFString: Any] = [
            kSecValueData: Data(value.utf8)
        ]
        let status = SecItemUpdate(searchQuery as CFDictionary, updateQuery as CFDictionary)
        if let error = KeychainError(rawValue: status) {
            throw error
        }
    }
}

// MARK: - KeychainManager+Singleton instance

extension KeychainManager {
    static let shared: KeychainManager = KeychainManager()
}

// MARK: - KeychainError

/// Keychain에서 사용되는 OSStatus code 중 에러에 해당되는 부분과 일부 매핑됩니다.
enum KeychainError: Int32, LocalizedError {
    case alreadyExists = -25299
    /// 지정된 키를 키체인에서 찾지 못함
    case keyNotFound = -25300
    /// 키체인이 존재하지 않을때, 권한 접근 오류
    case keychainNotFound = -25294
    /// query parameter가 잘못됨
    case invalidParameter = -50
    case encodingError = 100
    case decodingError = 101

    var errorDescription: String? {
        SecCopyErrorMessageString(rawValue, nil) as? String
    }
}

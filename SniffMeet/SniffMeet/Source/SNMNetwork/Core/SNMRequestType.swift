//
//  SNMRequestType.swift
//  SniffMeet
//
//  Created by sole on 11/16/24.
//

import Foundation

public enum SNMRequestType {
    case plain
    case header(with: [String: String])
    /// Content-Type: application/json이 자동으로 적용됩니다.
    case jsonEncodableBody(with: any Encodable)
    // TODO: MultipartFormData
}

//
//  SaveDeviceTokenDTO.swift
//  SniffMeet
//
//  Created by sole on 12/1/24.
//

struct SaveDeviceTokenDTO: Codable {
    let deviceToken: String

    enum CodingKeys: String, CodingKey {
        case deviceToken = "device_token"
    }
}

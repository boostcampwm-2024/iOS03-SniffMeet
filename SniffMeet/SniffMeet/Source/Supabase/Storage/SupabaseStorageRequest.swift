//
//  SupabaseStorageRequest.swift
//  SniffMeet
//
//  Created by sole on 11/24/24.
//

import Foundation

enum SupabaseStorageRequest {
    case upload(
        accessToken: String,
        image: Data,
        fileName: String,
        mimeType: MimeType
    )
    case download(fileName: String, lastModified: String)
}

// MARK: - SupabaseStorageRequest+SNMRequestConvertible

extension SupabaseStorageRequest: SNMRequestConvertible {
    var endpoint: Endpoint {
        switch self {
        case .upload(_, _, let fileName, _):
            Endpoint(
                baseURL: SupabaseConfig.baseURL,
                path: "storage/v1/object/\(SupabaseConfig.bucketName)/\(fileName)",
                method: .post
            )
        case .download(let fileName, _):
            Endpoint(
                baseURL: SupabaseConfig.baseURL,
                path: "storage/v1/object/\(SupabaseConfig.bucketName)/\(fileName)",
                method: .get
            )
        }
    }

    var requestType: SNMRequestType {
        switch self {
        case .upload(let accessToken, let imageData, let fileName, let mimeType):
                .multipartFormData(
                    header: [
                        "apiKey" : SupabaseConfig.apiKey,
                        "Authorization" : "Bearer \(accessToken)"
                    ],
                    multipartFormData: MultipartFormData(
                        parameters: [:],
                        fileName: fileName,
                        mimeType: mimeType.value,
                        contentData: imageData
                    )
                )
        case .download(_, let lastModified):
                .header(with: [
                    "apiKey" : SupabaseConfig.apiKey,
                    "If-Modified-Since": lastModified
                ])
        }
    }
}

enum MimeType {
    case plainText
    case imageJPEG
    case imagePNG
    case image

    var value: String {
        switch self {
        case .plainText: "text/plain"
        case .imageJPEG: "image/jpeg"
        case .imagePNG: "image/png"
        case .image: "image/*"
        }
    }
}

//
//  MultipartFormData.swift
//  SniffMeet
//
//  Created by sole on 11/17/24.
//

import Foundation

public struct MultipartFormData {
    private let crlf: String = "\r\n"
    let boundary: String
    private let parameters: [String: String]
    private let fileName: String
    private let mimeType: String
    private let contentData: Data

    public init(
        boundary: String = BoundaryGenerator.generate(),
        parameters: [String: String],
        fileName: String,
        mimeType: String,
        contentData: Data
    ) {
        self.boundary = boundary
        self.parameters = parameters
        self.fileName = fileName
        self.mimeType = mimeType
        self.contentData = contentData
    }

    var compositeBody: Data {
        var data: Data = Data()

        parameters.forEach { key, value in
            data.append("--\(boundary)\(crlf)")
            data.append(#"Content-Disposition: form-data; name="\#(key)""#)
            data.append("\(crlf)\(crlf)\(value)\(crlf)")
        }

        data.append("--\(boundary)\(crlf)")
        data.append(#"Content-Disposition: form-data; name="file"; filename="\#(fileName)""#)
        data.append("\(crlf)Content-Type: \(mimeType)\(crlf)\(crlf)")
        data.append(contentData)

        data.append("\(crlf)--\(boundary)--\(crlf)")
        
        return data
    }
}

public enum BoundaryGenerator {
    public static func generate() -> String {
        UUID().uuidString
    }
}

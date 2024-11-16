//
//  MultipartFormDataTests.swift
//  SniffMeet
//
//  Created by sole on 11/17/24.
//

import XCTest

final class MultipartFormDataTests: XCTestCase {
    func test_parameter가_있을때_mltp_form_data_생성() {
        // given
        let boundary: String = UUID().uuidString
        let parameter: [String: String] = ["team": "hgd"]
        // when
        let multipartFormData = MultipartFormData(
            boundary: boundary,
            parameters: parameter,
            fileName: "file.jpg",
            mimeType: "image/jpeg",
            contentData: Data("123".utf8)
        )
        let expectedString = """
                    --\(boundary)
                    Content-Disposition: form-data; name="team"
                    
                    hgd
                    --\(boundary)
                    Content-Disposition: form-data; name="file"; filename="file.jpg"
                    Content-Type: image/jpeg
                    
                    123
                    --\(boundary)--
                    
                    """.replacingOccurrences(of: "\r\n", with: "\n")
        let resultString = String(data: multipartFormData.compositeBody, encoding: .utf8)!
            .replacingOccurrences(of: "\r\n", with: "\n")
        // then
        XCTAssertEqual(resultString, expectedString)
    }
    func test_parameter가_없을때_mltp_form_data_생성() {
        // given
        let boundary: String = UUID().uuidString
        // when
        let multipartFormData = MultipartFormData(
            boundary: boundary,
            parameters: [:],
            fileName: "file.jpg",
            mimeType: "image/jpeg",
            contentData: Data("123".utf8)
        )
        let expectedString = """
                    --\(boundary)
                    Content-Disposition: form-data; name="file"; filename="file.jpg"
                    Content-Type: image/jpeg
                    
                    123
                    --\(boundary)--
                    
                    """.replacingOccurrences(of: "\r\n", with: "\n")
        let resultString = String(data: multipartFormData.compositeBody, encoding: .utf8)!
            .replacingOccurrences(of: "\r\n", with: "\n")
        // then
        XCTAssertEqual(resultString, expectedString)
    }
}

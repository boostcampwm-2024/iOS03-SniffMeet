//
//  SupabaseStorageTests.swift
//  SniffMeet
//
//  Created by sole on 11/24/24.
//

import UIKit
import XCTest

final class SupabaseStorageTests: XCTestCase {
    private var storageManager: (any RemoteImageManagable)!

    override func setUp() {
        self.storageManager = SupabaseStorageManager(
            networkProvider: SNMNetworkProvider()
        )
    }

    func test_이미지_다운로드후_이미지_변환에_성공해야_한다() async throws {
        // given
        // when
        let imageData = try await storageManager.download(fileName: "8AA2442D-1E09-41BC-BE92-50AC65C19367")
        // then
        XCTAssertNotNil(UIImage(data: imageData))
    }
    func test_이미지를_데이터로_변환후_업로드에_성공해야_한다() async throws {
        // given
        let image = UIImage(systemName: "square.and.arrow.up.fill")!
        let imageData = image.jpegData(compressionQuality: 1)!
        try await storageManager.upload(imageData: imageData, fileName: UUID().uuidString, mimeType: .image)
    }
}

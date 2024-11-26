//
//  FileManagerTest.swift
//  SNMPersistenceTests
//
//  Created by 윤지성 on 11/25/24.
//

import XCTest

final class FileManagerTest: XCTestCase {
    private var fileManagersut: SNMFileManager!
    private let testKey = "profileTest"
    private var isSaved = false

    override func setUp()  {
        fileManagersut = SNMFileManager()
    }

    override func tearDownWithError() throws {
        if isSaved {
            try fileManagersut.delete(forKey: testKey)
        }
        isSaved = false
    }
    
    func test_delete에서_삭제할_값이_없으면_에러를_반환한다() throws {
        XCTAssertThrowsError(try fileManagersut.delete(forKey: testKey)) { error in
            XCTAssert(error is FileManagerError)
            XCTAssertEqual(error as! FileManagerError, FileManagerError.deleteError)
        }
    }
    
    func test_이미지를_저장하고_가져올_수_있다() throws {
        // Arrange
        let image: UIImage = .app

        // Act
        XCTAssertFalse(fileManagersut.fileExists(forKey: testKey))
        try fileManagersut.set(image: image, forKey: testKey)
        guard let savedImage = try fileManagersut.get(forKey: testKey) else { XCTFail(); return}
        isSaved = true
        // Assert
        XCTAssertTrue(fileManagersut.fileExists(forKey: testKey))
    }
    
    func test_이미_이미지가_저장된파일에_이미지를_덮어쓸_수_있다() throws {
        // Arrange
        let firstImage: UIImage = .app
        let secondImage: UIImage = .imagePlaceholder

        // Act
        try fileManagersut.set(image: firstImage, forKey: testKey)
        guard let firstSavedImage = try fileManagersut.get(forKey: testKey) else {
            XCTFail()
            return
        }
        
        try fileManagersut.set(image: secondImage, forKey: testKey)
        guard let secondSavedImage = try fileManagersut.get(forKey: testKey) else {
            XCTFail()
            return
        }
        isSaved = true
        
        //Assert
        let comparison1 = firstImage.pngData()?.count ?? 0 > secondImage.pngData()?.count ?? 0
        let comparison2 = firstSavedImage.pngData()?.count ?? 0 > secondSavedImage.pngData()?.count ?? 0
        
        XCTAssertTrue(fileManagersut.fileExists(forKey: testKey))
        XCTAssertEqual(comparison1, comparison2)
    }
    
    func test_데이터가_삭제될_수_있다() throws {
        // Arrange
        let firstImage: UIImage = .app

        // Act
        try fileManagersut.set(image: firstImage, forKey: testKey)
        guard let beforeSavedImage = try fileManagersut.get(forKey: testKey) else {
            XCTFail()
            return
        }
        
        try fileManagersut.delete(forKey: testKey)
        
        //Assert
        XCTAssertThrowsError(try fileManagersut.delete(forKey: testKey)) { error in
            XCTAssert(error is FileManagerError)
            XCTAssertEqual(error as! FileManagerError, FileManagerError.deleteError)
        }
    }

}

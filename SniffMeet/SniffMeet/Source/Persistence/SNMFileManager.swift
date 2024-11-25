//
//  SNMFileManager.swift
//  SniffMeet
//
//  Created by 윤지성 on 11/25/24.
//
import UIKit

protocol ImageManagable {
    func get(forKey: String) throws -> UIImage?
    func set(image: UIImage, forKey: String) throws
    func delete(forKey: String) throws
}

struct SNMFileManager: ImageManagable {
    private var fileManager: FileManager { FileManager.default }
    private var documentsDir: URL? {
        fileManager.urls(for: .documentDirectory, in: .userDomainMask).first
    }
    
    func fileExists(forKey path: String) -> Bool {
        guard let documentsDir else {
            return false
        }
        let fileURL = documentsDir.appendingPathComponent(path, conformingTo: .png)
        if #available(iOS 16.0, *) {
            return fileManager.fileExists(atPath: fileURL.path())
        } else {
            return fileManager.fileExists(atPath: fileURL.path)
        }
    }
    
    func get(forKey: String) throws -> UIImage? {
        guard let documentsDir else {
            throw FileManagerError.directoryNotFound
        }
        let fileURL = documentsDir.appendingPathComponent(forKey, conformingTo: .png)
        guard fileManager.fileExists(atPath: fileURL.path) else {
            throw FileManagerError.fileNotFound
        }
        return UIImage(contentsOfFile: fileURL.path)
    }
    
    func set(image: UIImage, forKey: String) throws {
        guard let documentsDir else {
            throw FileManagerError.directoryNotFound
        }
        /// key 값을 받아 해당 키 값이 파일 이름인 파일을 생성한다.
        let fileURL = documentsDir.appendingPathComponent(forKey, conformingTo: .png)
       // SNMLogger.info(fileURL.absoluteString)
        
        guard let imageData = image.pngData() else {
            throw FileManagerError.dataConversionError
        }
        do {
            try imageData.write(to: fileURL)
        } catch {
            print(error.localizedDescription)
            throw FileManagerError.writeError
        }
    }
    
    func delete(forKey: String) throws {
        guard let documentsDir else {
            throw FileManagerError.directoryNotFound
        }
        let fileURL = documentsDir.appendingPathComponent(forKey, conformingTo: .png)
        do {
            try fileManager.removeItem(at: fileURL)
        } catch {
            throw FileManagerError.deleteError
        }
    }
}

enum FileManagerError: LocalizedError {
    case directoryNotFound
    case fileNotFound
    case dataConversionError
    case decodingError
    case noDeleteObject
    case writeError
    case deleteError

    var errorDescription: String? {
        switch self {
        case .directoryNotFound: "디렉터리를 찾을 수 없습니다."
        case .fileNotFound: "파일을 찾을 수 없습니다."
        case .dataConversionError: "이미지 데이터 변환 에러"
        case .decodingError: "디코딩 에러"
        case .noDeleteObject: "삭제할 대상을 찾을 수 없습니다."
        case .writeError: "파일 쓰기 에러"
        case .deleteError: "파일 삭제 에러"
        }
    }
}

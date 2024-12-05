//
//  Untitled.swift
//  SniffMeet
//
//  Created by 윤지성 on 12/5/24.
//
import Foundation

final class CacheableImage: Codable {
    let lastModified: String
    let imageData: Data

    init(lastModified: String, imageData: Data) {
        self.lastModified = lastModified
        self.imageData = imageData
    }
}

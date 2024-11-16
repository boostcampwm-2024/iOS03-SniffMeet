//
//  Data + append.swift
//  SniffMeet
//
//  Created by sole on 11/17/24.
//

import Foundation

extension Data {
    mutating func append(_ string: String) {
        self.append(Data(string.utf8))
    }
}

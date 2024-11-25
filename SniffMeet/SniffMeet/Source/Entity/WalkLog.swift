//
//  WalkLog.swift
//  SniffMeet
//
//  Created by sole on 11/24/24.
//

import Foundation

struct WalkLog {
    let step: Int
    let distance: Double
    let startDate: Date
    let endDate: Date
    let image: Data?

    var duration: TimeInterval {
        endDate.timeIntervalSince(startDate)
    }
}

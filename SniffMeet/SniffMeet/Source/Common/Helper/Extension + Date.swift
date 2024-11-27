//
//  Extension + Date.swift
//  SniffMeet
//
//  Created by 윤지성 on 11/26/24.
//
import Foundation

extension Date {
    func secondsDifferenceFromNow() -> Int {
        let currentDate = Date()
        let calendar = Calendar.current
        let components = calendar.dateComponents([.second], from: self, to: currentDate)
        
        return components.second ?? 0
    }
}

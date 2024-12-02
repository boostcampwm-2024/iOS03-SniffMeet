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
    
    func convertDateToISO8601String() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC") // UTC 설정
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // 권장 로케일 설정
        return dateFormatter.string(from: self)
    }
}

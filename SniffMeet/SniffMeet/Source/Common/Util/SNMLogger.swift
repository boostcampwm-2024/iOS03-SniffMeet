//
//  SNMLogger.swift
//  SniffMeet
//
//  Created by sole on 11/20/24.
//

import OSLog

enum SNMLogger {
    private static let logger: Logger = Logger(subsystem: "SniffMeet", category: "SNMLogger")

    /// debug 레벨에서 사용합니다.
    static func print(_ message: String...) {
        logger.debug("⚙️ \(message.joined(separator: " "))")
    }
    static func error(_ message: String...) {
        logger.error("🚨 \(message.joined(separator: " "))")
    }
    static func info(_ message: String...) {
        logger.info("📄 \(message.joined(separator: " "))")
    }
    static func log(level: OSLogType = .default, _ message: String...) {
        logger.log(level: level, "\(message.joined(separator: " "))")
    }
}

//
//  HTTPStatusCode.swift
//  SniffMeet
//
//  Created by sole on 11/16/24.
//

public enum HTTPStatusCode: Int {
    case okCode = 200
    case created = 201
    case accepted = 202
    case noContent = 204
    case resetContent = 205
    case partialContent = 206
    case multipleChoices = 300
    case movedPermanently = 301
    case found = 302
    case seeOther = 303
    case notModified = 304
    case temporaryRedirect = 307
    case badRequest = 400
    case unauthorization = 401
    case forbidden = 403
    case notFound = 404
    case methodNotAllowed = 405
    case notAcceptable = 406
    case proxyAuthenticationRequired = 407
    case requestTimeout = 408
    case conflict = 409
    case gone = 410
    case lengthRequired = 411
    case preconditionFailed = 412
    case contentTooLarge = 413
    case urlTooLong = 414
    case unsupportMediaType = 415
    case rangeNotSatisfiable = 416
    case expectationFailed = 417
    case misdirectedRequest = 421
    case tooManyRequests = 429
    case requestHeaderFieldsTooLarge = 431
    case internalServerError = 500
    case notImplemented = 501
    case badGateway = 502
    case serviceUnavailable = 503
    case gatewayTimeout = 504
    case httpVersionNotSupported = 505
    case insufficientStorage = 507
    case notExtended = 510

    /// 성공코드인지 확인합니다.
    var isSuccess: Bool {
        200...299 ~= self.rawValue
    }
}

//
//  Provider.swift
//  HGDNetwork
//
//  Created by 윤지성 on 11/7/24.
//

import Foundation

protocol NetworkProvider {
    func request(with: any SNMRequestConvertible) async throws -> SNMNetworkResponse
}

public final class SNMNetworkProvider: NetworkProvider {
    private let session: URLSession

    public init(session: URLSession = .shared) {
        self.session = session
    }

    public func request(
        with request: any SNMRequestConvertible
    ) async throws -> SNMNetworkResponse {
        let (data, response) = try await session.data(for: request.urlRequest())
        guard let httpResponse = response as? HTTPURLResponse
        else { throw SNMNetworkError.invalidResponse(response: response) }
        try mapHttpStatusCode(statusCode: httpResponse.statusCode)
        let snmResponse = SNMNetworkResponse(statusCode: httpResponse.statusCode, data: data)
        return snmResponse
    }
    /// HTTPStatusCode에 따라 SNMNetworkError로 변경합니다.
    private func mapHttpStatusCode(statusCode: Int) throws {
        switch statusCode {
        case 200...299: break
        case 300...399:
            throw SNMNetworkError.redirection
        case 400:
            throw SNMNetworkError.badRequest
        case 401:
            throw SNMNetworkError.unAuthorization
        case 403:
            throw SNMNetworkError.forbidden
        case 404:
            throw SNMNetworkError.notFound
        case 405:
            throw SNMNetworkError.methodNotAllowed
        case 413:
            throw SNMNetworkError.contentTooLarge
        case 414:
            throw SNMNetworkError.urlTooLong
        case 415:
            throw SNMNetworkError.unsupportMediaType
        case 500...599:
            throw SNMNetworkError.serverError
        default:
            throw SNMNetworkError.invalidStatusCode(statusCode: statusCode)
        }
    }
}

public enum SNMNetworkError: LocalizedError {
    // SNMNetwork Error
    case encodingError(with: any Encodable)
    case invalidRequest(request: any SNMRequestConvertible)
    case invalidURL(url: URL)
    case invalidStatusCode(statusCode: Int)
    /// HTTPResponse로 변환 실패
    case invalidResponse(response: URLResponse)
    // Status code 300번대
    // TODO: Redirect는 따로 처리 과정이 필요함
    case redirection
    // Status code 400번대
    case badRequest
    case unAuthorization
    case notFound
    case forbidden
    case methodNotAllowed
    case contentTooLarge
    case urlTooLong
    case unsupportMediaType
    // Status code 500번대
    case serverError

    public var errorDescription: String? {
        switch self {
        case .encodingError(let data):
            "인코딩 에러입니다. \(data)"
        case .invalidRequest(let request):
            "잘못된 요청입니다. \(request)"
        case .invalidURL(let url):
            "URL이 잘못되었습니다. \(url)"
        case .invalidResponse(let response):
            "HTTP 응답이 아닙니다. \(response)"
        case .invalidStatusCode(let statusCode):
            "잘못된 status code입니다. \(statusCode)"
        case .redirection:
            "리디렉션"
        case .badRequest:
            "잘못된 요청입니다."
        case .unAuthorization:
            "권한이 없습니다."
        case .notFound:
            "요청한 콘텐츠를 찾을 수 없습니다."
        case .forbidden:
            "금지된 접근입니다."
        case .methodNotAllowed:
            "허용되지 않은 메서드입니다."
        case .contentTooLarge:
            "요청 본문이 서버에서 정의한 제한보다 큽니다."
        case .urlTooLong:
            "URL이 너무 길어서 요청이 실패하였습니다."
        case .unsupportMediaType:
            "요청된 데이터의 미디어 형식이 서버에서 지원되지 않습니다."
        case .serverError:
            "서버 에러입니다."
        }
    }
}

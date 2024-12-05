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
        do {
            let (data, response) = try await session.data(for: request.urlRequest())
            guard let httpResponse = response as? HTTPURLResponse,
                  let status = HTTPStatusCode(rawValue: httpResponse.statusCode)
            else {
                throw SNMNetworkError.invalidResponse(response: response)
            }
            guard status.isSuccess
            else {
                throw SNMNetworkError.failedStatusCode(reason: status)
            }
            let snmResponse = SNMNetworkResponse(
                statusCode: status,
                data: data,
                header: httpResponse.allHeaderFields
            )
            return snmResponse
        } catch let error as URLError {
            throw SNMNetworkError.urlError(urlError: error)
        }
        catch let error as SNMNetworkError {
            throw error
        } catch {
            throw SNMNetworkError.unknown(error: error)
        }
    }
}

public enum SNMNetworkError: LocalizedError {
    case encodingError(with: any Encodable)
    case invalidRequest(request: any SNMRequestConvertible)
    case invalidURL(url: URL)
    case urlError(urlError: URLError)
    /// HTTPResponse로 변환 실패
    case invalidResponse(response: URLResponse)
    /// 실패로 분류되는 StatusCode입니다.
    case failedStatusCode(reason: HTTPStatusCode)
    case unknown(error: any Error)

    public var errorDescription: String? {
        switch self {
        case .encodingError(let data):
            "인코딩 에러입니다. \(data)"
        case .invalidRequest(let request):
            "잘못된 요청입니다. \(request)"
        case .invalidURL(let url):
            "URL이 잘못되었습니다. \(url)"
        case .urlError(let urlError):
            "URLError가 발생했습니다. \(urlError.localizedDescription)"
        case .invalidResponse(let response):
            "HTTP 응답이 아닙니다. \(response)"
        case .failedStatusCode(let reason):
            "실패 코드를 반환했습니다. statusCode: \(reason.rawValue)"
        case .unknown(let error):
            "알 수없는 에러입니다. \(error.localizedDescription)"
        }
    }
}

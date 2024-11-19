//
//  EndPoint.swift
//  HGDNetwork
//
//  Created by 윤지성 on 11/7/24.
//

import Foundation

public struct Endpoint {
    public var baseURL: URL
    public var path: String
    public var method: HTTPMethod
    public var query: [String: String]?
    /// path와 query를 조합한 URL입니다. 조합에 실패시 baseURL을 반환합니다. 
    public var absoluteURL: URL  {
        let absoluteURLString: String = baseURL.absoluteString.trimmingCharacters(
            in: CharacterSet(charactersIn: "/")
        )
        var components = URLComponents(string: absoluteURLString)
        components?.queryItems = query?.compactMap {
            URLQueryItem(name: $0, value: $1)
        }
        let previousPath = components?.path ?? ""
        components?.path = previousPath + "/\(path)"
        return components?.url ?? baseURL
    }
}

public enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case delete = "DELETE"
    case put = "PUT"
    case patch = "PATCH"
}

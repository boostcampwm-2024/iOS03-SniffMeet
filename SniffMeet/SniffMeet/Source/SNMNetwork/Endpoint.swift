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
        var absoluteURLString: String = baseURL.absoluteString + "/"
        // 의미없는 / 제거
        let pathComponents = path.components(separatedBy: "/")
                                .compactMap{ $0.isEmpty ? nil : $0 }
        let queryPathString: String = query?.map{ "\($0)=\($1)" }.joined(separator: "&") ?? ""
        absoluteURLString += pathComponents.joined(separator: "/")
        if !queryPathString.isEmpty {
            absoluteURLString += "?\(queryPathString)"
        }
    
        return URL(string: absoluteURLString) ?? baseURL
    }
}

public enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case delete = "DELETE"
    case put = "PUT"
    case patch = "PATCH"
}

//
//  Response.swift
//  HGDNetwork
//
//  Created by 윤지성 on 11/7/24.
//
import Foundation

public final class SNMNetworkResponse {
    public let statusCode: HTTPStatusCode
    public let data: Data
    public let response: HTTPURLResponse?
    public let header: [AnyHashable : Any]?

    public init(
        statusCode: HTTPStatusCode,
        data: Data,
        response: HTTPURLResponse? = nil,
        header: [AnyHashable : Any]?
    ) {
        self.statusCode = statusCode
        self.data = data
        self.response = response
        self.header = header
    }
}

extension SNMNetworkResponse: CustomDebugStringConvertible, Equatable {
    public var description: String {
        "Status Code: \(statusCode), Data Length: \(data.count)"
    }
    
    public var debugDescription: String { description }
    
    public static func == (lhs: SNMNetworkResponse, rhs: SNMNetworkResponse) -> Bool {
        lhs.statusCode == rhs.statusCode
        && lhs.data == rhs.data
        && lhs.response == rhs.response
    }
}


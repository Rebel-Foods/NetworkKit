//
//  NetworkRequest.swift
//  NetworkKit
//
//  Created by Raghav Ahuja on 15/10/19.
//  Copyright © 2019 Raghav Ahuja. All rights reserved.
//

import Foundation

public typealias NetworkRequest = NKRequest

public class NKRequest {

    var bodyData: Data? = nil
    var headers: HTTPHeaderParameters = [:]
    
    var queryItems = Set<URLQueryItem>()
    
    private var _request: URLRequest? = nil
    
    public var request: URLRequest? {
        _request
    }
    
    public let apiName: String
    
    public let connection: ConnectionRepresentable
    
    public init(to endPoint: ConnectionRepresentable) {
        connection = endPoint
        apiName = endPoint.name ?? "Nil"
    }
    
    public func create() {
        let creator = CreateRequest(with: connection, query: queryItems, body: bodyData, headers: headers)
        _request = creator?.request
    }
    
    public func urlQuery(_ query: URLQuery) -> Self {
        queryItems.addURLQuery(query: query)
        return self
    }
    
    public func requestBody<T: Encodable>(_ body: T, strategy: JSONEncoder.KeyEncodingStrategy = .useDefaultKeys) -> Self {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = strategy
        encoder.outputFormatting = .prettyPrinted
        
        do {
            let bodyData = try encoder.encode(body)
            self.bodyData = bodyData
        } catch {
            bodyData = nil
        }
        
        headers = headers.merging(HTTPBodyEncodingType.json.headers) { (_, new) in new }
        
        return self
    }
    
    public func requestBody(_ body: [String: Any], encoding: HTTPBodyEncodingType) -> Self {
        bodyData = encoding.encode(body: body)
        
        headers = headers.merging(encoding.headers) { (_, new) in new }
        
        return self
    }
    
    public func requestBody(_ body: Data?, httpHeaders: HTTPHeaderParameters) -> Self {
        bodyData = body
        headers = headers.merging(httpHeaders) { (_, new) in new }
        
        return self
    }
    
    public func httpHeaders(_ httpHeaders: HTTPHeaderParameters) -> Self {
        headers = headers.merging(httpHeaders) { (_, new) in new }
        
        return self
    }
}

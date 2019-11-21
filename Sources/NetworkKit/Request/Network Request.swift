//
//  NetworkRequest.swift
//  NetworkKit
//
//  Created by Raghav Ahuja on 15/10/19.
//  Copyright © 2019 Raghav Ahuja. All rights reserved.
//

import Foundation

public final class NetworkRequest {
    
    public private(set) var request: URLRequest?
    
    public let apiName: String
    
    public init(to endPoint: ConnectionRepresentable) {
        request = CreateRequest(with: endPoint, query: nil)?.request
        apiName = endPoint.name ?? "nil"
    }
    
    public func urlQuery(_ query: URLQuery) -> Self {
        guard let url = request?.url?.absoluteURL,
            var components = URLComponents(string: url.absoluteString) else {
            return self
        }
        
        var items = components.queryItems ?? []
        items.addURLQuery(query: query)
        components.queryItems = items
        
        self.request?.url = components.url
        
        #if DEBUG
        DebugPrint.print(
            """
            Request Dynamic URLQuery:
            \(items.toDictionary.prettyPrint)
            
            ---------------------------------------------
            """
        )
        #endif
        return self
    }
    
    public func requestBody<T: Encodable>(_ body: T, strategy: JSONEncoder.KeyEncodingStrategy = .useDefaultKeys) -> Self {
        guard request != nil else {
            return self
        }
        
        var data: Data? = nil
        
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = strategy
        encoder.outputFormatting = .prettyPrinted
        
        do {
            let bodyData = try encoder.encode(body)
            data = bodyData
            
            #if DEBUG
            DebugPrint.print(
                """
                Request Body:
                \(String(data: bodyData, encoding: .utf8) ?? "nil")
                
                ---------------------------------------------
                """
            )
            #endif
        } catch {
            #if DEBUG
            DebugPrint.print(
                """
                Request Body: nil
                Error Encoding: -
                \(error)
                
                ---------------------------------------------
                """
            )
            #endif
            
            data = nil
        }
        
        request?.httpBody = data
        
        var headers = request?.allHTTPHeaderFields ?? [:]
        headers = headers.merging(HTTPBodyEncodingType.json.headers) { (_, new) in new }
        request?.allHTTPHeaderFields = headers
        
        return self
    }
    
    public func requestBody(_ body: [String: Any], encoding: HTTPBodyEncodingType) -> Self {
        guard request != nil else {
            return self
        }
        
        #if DEBUG
        DebugPrint.print("""
            Request Body:
            \(body.prettyPrint)
            
            ---------------------------------------------
            """)
        #endif
        
        request?.httpBody = encoding.encode(body: body)
        
        var headers = request?.allHTTPHeaderFields ?? [:]
        headers = headers.merging(encoding.headers) { (_, new) in new }
        request?.allHTTPHeaderFields = headers
        
        return self
    }
    
    public func requestBody(_ body: Data?, httpHeaders: HTTPHeaderParameters) -> Self {
        guard request != nil else {
            return self
        }
        
        request?.httpBody = body
        
        var headers = request?.allHTTPHeaderFields ?? [:]
        headers = headers.merging(httpHeaders) { (_, new) in new }
        request?.allHTTPHeaderFields = headers
        
        return self
    }
    
    public func httpHeaders(_ httpHeaders: HTTPHeaderParameters) -> Self {
        guard request != nil else {
            return self
        }
        
        var headers = request?.allHTTPHeaderFields ?? [:]
        headers = headers.merging(httpHeaders) { (_, new) in new }
        request?.allHTTPHeaderFields = headers
        
        return self
    }
}


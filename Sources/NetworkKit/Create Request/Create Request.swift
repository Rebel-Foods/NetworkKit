//
//  CreateRequest.swift
//  NetworkKit
//
//  Created by Raghav Ahuja on 15/10/19.
//  Copyright © 2019 Raghav Ahuja. All rights reserved.
//

import Foundation

public typealias URLQuery = [String: String?]
public typealias HTTPHeaderParameters = [String: String]

public struct CreateRequest {
    
    public let request: URLRequest
    
    public init?(with connection: ConnectionRepresentable, query urlQuery: URLQuery?) {
        
        var components = URLComponents()
        components.scheme = connection.scheme.rawValue
        
        let subURL = connection.apiType?.subUrl ?? ""
        let endPoint = connection.apiType?.endPoint ?? ""
        
        components.host = (subURL.isEmpty ? subURL : subURL + ".") + connection.host.host
        components.path = endPoint + connection.path
        
        var queryItems: [URLQueryItem] = []
        queryItems.addURLQuery(query: urlQuery)
        queryItems.addURLQuery(query: connection.defaultQuery)
        queryItems.addURLQuery(query: connection.host.defaultUrlQuery)
        
        let method = connection.method
        
        if !queryItems.isEmpty {
            components.queryItems = queryItems
        }
        
        guard let url = components.url else {
            return nil
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        
        let defaultHeaderFields = connection.host.defaultHeaders
        let connectionHeaderFields = connection.httpHeaders
        
        let headerFields = defaultHeaderFields.merging(connectionHeaderFields) { (_, new) in new }
        
        if !headerFields.isEmpty {
            urlRequest.allHTTPHeaderFields = headerFields
        }
        request = urlRequest
        
        #if DEBUG
        DebugPrint.logAPIRequest(request: request, apiName: connection.name)
        #endif
    }
}

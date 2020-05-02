//
//  Request+Create.swift
//  NetworkKit
//
//  Created by Raghav Ahuja on 15/10/19.
//

import Foundation

#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

public typealias URLQuery = [String: String?]
public typealias HTTPHeaderParameters = [String: String]

extension NKRequest {
    
    /// Creates the `URLRequest` from `NKRequest`.
    public func create() {
        
        var components = URLComponents()
        components.scheme = connection.scheme.rawValue
        
        let subURL = connection.apiType?.subURL ?? ""
        let endPoint = connection.apiType?.endPoint ?? ""
        
        components.host = (subURL.isEmpty ? subURL : subURL + ".") + connection.host.host
        components.path = endPoint + connection.path
        
        var queryItems = Set<URLQueryItem>()
        queryItems.addURLQuery(query: connection.defaultQuery)
        queryItems.addURLQuery(query: connection.host.defaultURLQuery)
        queryItems = queryItems.union(self.queryItems)
        
        let method = connection.method
        
        if !queryItems.isEmpty {
            components.queryItems = Array(queryItems)
        }
        
        guard let url = components.url else {
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.networkServiceType = networkServiceType
        urlRequest.httpMethod = method.rawValue
        
        let defaultHeaderFields = connection.host.defaultHeaders
        let connectionHeaderFields = connection.httpHeaders
        
        var headerFields = defaultHeaderFields.merging(connectionHeaderFields) { (_, new) in new }
        headerFields.merge(headers) { (_, new) in new }
        
        if !headerFields.isEmpty {
            urlRequest.allHTTPHeaderFields = headerFields
        }
        
        urlRequest.httpBody = bodyData
        _request = urlRequest
    }
}

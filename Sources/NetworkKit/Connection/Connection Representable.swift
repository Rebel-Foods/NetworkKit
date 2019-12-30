//
//  ConnectionRepresentable.swift
//  NetworkKit
//
//  Created by Raghav Ahuja on 15/10/19.
//  Copyright © 2019 Raghav Ahuja. All rights reserved.
//

import Foundation

/**
 A type that represents as a connection or an endpoint.
 
 ```
 let url = "https://api.example.com/users/all"
 // `/users/all` is a connection.
 ```
 */
public protocol ConnectionRepresentable {
    
    /**
     The path subcomponent. It is the connection endpoint for the url.
     
     ```
     let url = "https://api.example.com/users/all"
     // `/users/all` is the path for this connection
     ```
    
     Setting this property assumes the subcomponent or component string is not percent encoded and will add percent encoding (if the component allows percent encoding).
 */
    var path: String { get }
    
    /// Connection name if any. Use for console logging. Defaults to connection url if provided `nil`.
    var name: String? { get }   // for console logging purposes only
    
    /// HTTP Method for the connection request.
    var method: HTTPMethod { get }
    
    /// Default Headers attached to connection request. Example: ["User-Agent": "iOS_13_0"]
    var httpHeaders: HTTPHeaderParameters { get }
    
    /// The scheme subcomponent of the URL. Default value is `.https`
    var scheme: Scheme { get }
    
    /// Host for the connection.
    var host: HostRepresentable { get }
    
    /// Default URL Query for connection. Example: ["client": "ios"]
    var defaultQuery: URLQuery? { get }
    
    /// API Type for connection. Default value is `host.defaultAPIType`.
    var apiType: APIRepresentable? { get }
}

public extension ConnectionRepresentable {
    
    var scheme: Scheme { .https }
    
    var apiType: APIRepresentable? { host.defaultAPIType }
}

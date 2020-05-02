//
//  Host Representable.swift
//  NetworkKit
//
//  Created by Raghav Ahuja on 15/10/19.
//

/**
A type that represents a URL host.
 
```
let url = "https://api.example.com/users/all"
// `example.com` is a host.
```
 
*/
public protocol HostRepresentable {
    
    /// Host name.
    var host: String { get }
    
    /// Default Headers attached to every request with this host.
    var defaultHeaders: HTTPHeaderParameters { get }
    
    /// Default URL Query for particular host.
    var defaultURLQuery: URLQuery? { get }
    
    /// Default API Type for particular host.
    var defaultAPIType: APIRepresentable? { get }
}

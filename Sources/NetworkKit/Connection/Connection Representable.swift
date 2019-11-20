//
//  ConnectionRepresentable.swift
//  NetworkKit
//
//  Created by Raghav Ahuja on 15/10/19.
//  Copyright © 2019 Raghav Ahuja. All rights reserved.
//

import Foundation

public protocol ConnectionRepresentable {
    var path: String { get }
    var name: String? { get }   // for console logging purposes only
    var method: HTTPMethod { get }
    var httpHeaders: HTTPHeaderParameters { get }
    var scheme: Scheme { get }
    var host: HostRepresentable { get }
    var defaultQuery: URLQuery? { get }
    var apiType: APIRepresentable? { get }
}

public extension ConnectionRepresentable {
    var scheme: Scheme { .https }
    
    var apiType: APIRepresentable? { host.defaultAPIType }
}

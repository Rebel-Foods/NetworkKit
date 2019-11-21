//
//  NKSession.swift
//  NetworkKit
//
//  Created by Raghav Ahuja on 15/10/19.
//  Copyright © 2019 Raghav Ahuja. All rights reserved.
//

import Foundation

final public class NKSession: NetworkConfiguration {
    
    public static let shared = NKSession()
    
    private init() {
        super.init(configuration: NetworkConfiguration.defaultConfiguration)
        
        #if DEBUG
        if let environmentValue = UserDefaults.standard.value(forKey: "api_environment") as? String, !environmentValue.isEmpty {
            Environment.current = Environment(value: environmentValue)
        } else {
            Environment.current = .none
        }
        #else
        Environment.current = .none
        #endif
    }
    
    /// Returns a publisher that wraps a URL session data task for a given Network request.
    ///
    /// The publisher publishes data when the task completes, or terminates if the task fails with an error.
    /// - Parameter builder: The block which returns a `NetworkRequest` to create a URL session data task.
    /// - Parameter apiName: API Name for debug console logging.
    /// - Returns: A publisher that wraps a data task for the URL request.
    public func dataTask(_ builder: () -> NetworkRequest) -> NetworkTask {
        NetworkTask(session: session, builder)
    }
    
    /// Returns a publisher that wraps a URL session data task for a given URL request.
    ///
    /// The publisher publishes data when the task completes, or terminates if the task fails with an error.
    /// - Parameter request: The URL request for which to create a data task.
    /// - Parameter apiName: API Name for debug console logging.
    /// - Returns: A publisher that wraps a data task for the URL request.
    public func dataTask(for request: URLRequest, apiName: String? = nil) -> NetworkTask {
        NetworkTask(request: request, session: session, apiName: apiName)
    }
    
    /// Returns a publisher that wraps a URL session data task for a given URL.
    ///
    /// The publisher publishes data when the task completes, or terminates if the task fails with an error.
    /// - Parameter url: The URL for which to create a data task.
    /// - Parameter apiName: API Name for debug console logging.
    /// - Returns: A publisher that wraps a data task for the URL.
    public func dataTask(for url: URL, apiName: String? = nil) -> NetworkTask {
        NetworkTask(url: url, session: session, apiName: apiName)
    }
}

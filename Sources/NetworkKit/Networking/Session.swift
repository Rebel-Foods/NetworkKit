//
//  NKSession.swift
//  NetworkKit
//
//  Created by Raghav Ahuja on 15/10/19.
//  Copyright © 2019 Raghav Ahuja. All rights reserved.
//

import Foundation
import PublisherKit

extension URLSession.NKDataTaskPublisher {
    
    public func validate() -> NKPublishers.Validate {
        NKPublishers.Validate(upstream: self, shouldCheckForErrorModel: true, acceptableStatusCodes: NKSession.shared.acceptableStatusCodes)
    }
}

public typealias NKTask = URLSession.NKDataTaskPublisher
public typealias NKAnyCancellable = PublisherKit.NKAnyCancellable
public typealias NKPublishers = PublisherKit.NKPublishers

final public class NKSession: NKConfiguration {
    
    public static let shared = NKSession()
    
    private let queue = DispatchQueue(label: "com.networkkit.task-thread", qos: .utility, attributes: .concurrent, autoreleaseFrequency: .inherit, target: nil)
    
    private init() {
        super.init(configuration: NKConfiguration.defaultConfiguration)
        
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
    public func dataTask(file: StaticString = #file, line: UInt = #line, function: StaticString = #function, _ builder: () -> NKRequest) -> URLSession.NKDataTaskPublisher {
        let creator = builder()
        let urlRequest: URLRequest? = queue.sync {
            creator.create()
            return creator.request
        }
        
        guard let request = urlRequest else {
            NKLogger.default.preconditionFailure("Invalid Request Created", file: file, line: line, function: function)
        }
        
        return session.nkTaskPublisher(for: request, apiName: creator.apiName)
    }
    
    /// Returns a publisher that wraps a URL session data task for a given URL request.
    ///
    /// The publisher publishes data when the task completes, or terminates if the task fails with an error.
    /// - Parameter request: The URL request for which to create a data task.
    /// - Parameter apiName: API Name for debug console logging.
    /// - Returns: A publisher that wraps a data task for the URL request.
    public func dataTask(for request: URLRequest, apiName: String? = nil) -> URLSession.NKDataTaskPublisher {
        session.nkTaskPublisher(for: request)
    }
    
    /// Returns a publisher that wraps a URL session data task for a given URL.
    ///
    /// The publisher publishes data when the task completes, or terminates if the task fails with an error.
    /// - Parameter url: The URL for which to create a data task.
    /// - Parameter apiName: API Name for debug console logging.
    /// - Returns: A publisher that wraps a data task for the URL.
    public func dataTask(for url: URL, apiName: String? = nil) -> URLSession.NKDataTaskPublisher {
        session.nkTaskPublisher(for: url)
    }
}

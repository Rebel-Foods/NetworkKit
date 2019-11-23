//
//  NetworkTask.swift
//  NetworkKit
//
//  Created by Raghav Ahuja on 15/10/19.
//  Copyright © 2019 Raghav Ahuja. All rights reserved.
//

import Foundation

public struct NetworkTask: NKPublisher {
    
    public var result: NKResult<Output, Failure>
    
    public var queue: NKQueue
    
    public typealias Output = (data: Data, response: HTTPURLResponse)
    
    public typealias Failure = NSError
    
    public let request: URLRequest?
    
    public let session: URLSession
    
    private let operationQueue: OperationQueue = {
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 1
        queue.qualityOfService = .utility
        queue.isSuspended = true
        return queue
    }()
    
    /// Creates a data task from the provided Network Request and URL session.
    /// - Parameter session: The `URLSession` from `NetworkConfiguration` to create the data task.
    /// - Parameter builder: The block which returns a `NetworkRequest` to create a URL session data task.
    public init(session: NetworkConfiguration, _ builder: () -> NetworkRequest) {
        self.init(session: session.session, builder)
    }
    
    /// Creates a data task from the provided URL request and URL session.
    /// - Parameter request: The `URLRequest` from which to create a URL session data task.
    /// - Parameter session: The `URLSession` from `NetworkConfiguration` to create the data task.
    /// - Parameter apiName: API Name for debug console logging.
    public init(request: URLRequest, session: NetworkConfiguration, apiName: String? = nil) {
        self.init(request: request, session: session.session, apiName: apiName)
    }
    
    
    /// Creates a data task from the provided URL and URL session.
    /// - Parameter url: The `URL` from which to create a URL session data task.
    /// - Parameter session: The `URLSession` from `NetworkConfiguration` to create the data task.
    /// - Parameter apiName: API Name for debug console logging.
    public init(url: URL, session: NetworkConfiguration, apiName: String? = nil) {
        self.init(url: url, session: session.session, apiName: apiName)
    }
    
    /// Creates a data task from the provided Network Request and URL session.
    /// - Parameter session: The `URLSession` to create the data task.
    /// - Parameter builder: The block which returns a `NetworkRequest` to create a URL session data task.
    public init(session: URLSession, _ builder: () -> NetworkRequest) {
        let requestBuilder = DispatchQueue.global(qos: .utility).sync { builder() }
        
        self.session = session
        
        request = requestBuilder.request
        
        result = .init()
        queue = .init(operationQueue: operationQueue,
                      request: requestBuilder.request,
                      apiName: requestBuilder.apiName)
        resume()
    }
    
    /// Creates a data task from the provided URL request and URL session.
    /// - Parameter request: The `URLRequest` from which to create a URL session data task.
    /// - Parameter session: The `URLSession` to create the data task.
    /// - Parameter apiName: API Name for debug console logging.
    public init(request: URLRequest, session: URLSession, apiName: String? = nil) {
        self.request = request
        
        self.session = session
        
        result = .init()
        queue = .init(operationQueue: operationQueue,
                      request: request,
                      apiName: apiName)
        resume()
    }
    
    /// Creates a data task from the provided URL and URL session.
    /// - Parameter url: The `URL` from which to create a URL session data task.
    /// - Parameter session: The `URLSession` to create the data task.
    /// - Parameter apiName: API Name for debug console logging.
    public init(url: URL, session: URLSession, apiName: String? = nil) {
        request = URLRequest(url: url)
        
        self.session = session
        
        result = .init()
        queue = .init(operationQueue: operationQueue,
                      request: request,
                      apiName: apiName)
        resume()
    }
    
    private func resume() {
        let fetchOperation = FetchOperation(session: session, request: request, result: result)
        addToQueue(isSuspended: true, fetchOperation)
    }
}

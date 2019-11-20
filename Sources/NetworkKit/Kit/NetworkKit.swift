//
//  NetworkKit.swift
//  NetworkKit
//
//  Created by Raghav Ahuja on 15/10/19.
//  Copyright © 2019 Raghav Ahuja. All rights reserved.
//

import Foundation

public struct NetworkKit: NetworkPublisher {
    
    public var result: NetworkResult<Output, Failure>
    
    public var queue: NetworkQueue
    
    public typealias Output = (data: Data, response: HTTPURLResponse)
    
    public typealias Failure = NKError
    
    public let request: URLRequest?
    
    private let operationQueue: OperationQueue = {
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 1
        queue.qualityOfService = .utility
        queue.isSuspended = true
        return queue
    }()
    
    public init(_ builder: () -> NetworkRequest) {
        
        let requestBuilder = DispatchQueue.global(qos: .utility).sync { builder() }
        request = requestBuilder.request
        
        result = .init()
        queue = .init(operationQueue: operationQueue,
                      request: requestBuilder.request,
                      apiName: requestBuilder.apiName)
        resume()
    }
    
    private func resume() {
        let fetchOperation = FetchOperation(request: request, result: result)
        addToQueue(isSuspended: true, fetchOperation)
    }
}

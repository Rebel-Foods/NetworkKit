//
//  Catch.swift
//  NetworkKit
//
//  Created by Raghav Ahuja on 18/11/19.
//  Copyright © 2019 Raghav Ahuja. All rights reserved.
//

import Foundation

public extension NKPublishers {
    
    struct Catch<Upstream: NKPublisher, NewPublisher: NKPublisher>: NKPublisher where Upstream.Output == NewPublisher.Output {
        
        public var result: NKResult<Output, Failure>
        
        public var queue: NKQueue {
            upstream.queue
        }
        
        public typealias Output = Upstream.Output

        public typealias Failure = NewPublisher.Failure

        /// The publisher that this publisher receives elements from.
        public let upstream: Upstream

        /// A closure that accepts the upstream failure as input and returns a publisher to replace the upstream publisher.
        public let handler: (Upstream.Failure) -> NewPublisher
        
        /// Creates a publisher that handles errors from an upstream publisher by replacing the failed publisher with another publisher.
        ///
        /// - Parameters:
        ///   - upstream: The publisher that this publisher receives elements from.
        ///   - handler: A closure that accepts the upstream failure as input and returns a publisher to replace the upstream publisher.
        public init(upstream: Upstream, handler: @escaping (Upstream.Failure) -> NewPublisher) {
            self.upstream = upstream
            self.handler = handler
            result = .init()
            
            let operation = CatchOperation(upstream: upstream, handler: handler, result: result)
            addToQueue(operation)
        }
    }
}


final class CatchOperation<Upstream: NKPublisher, NewPublisher: NKPublisher>: AsynchronousOperation where Upstream.Output == NewPublisher.Output {

    public typealias Output = Upstream.Output

    public typealias Failure = NewPublisher.Failure

    /// The publisher that this publisher receives elements from.
    private let upstream: Upstream
    
    private var result: NKResult<Output, Failure>

    /// A closure that accepts the upstream failure as input and returns a publisher to replace the upstream publisher.
    private let handler: (Upstream.Failure) -> NewPublisher
    
    init(upstream: Upstream, handler: @escaping (Upstream.Failure) -> NewPublisher, result: NKResult<Output, Failure>) {
        self.upstream = upstream
        self.handler = handler
        self.result = result
    }
    
    override func main() {
        switch upstream.result.result {
        case .success(let output):
            result.result = .success(output)
            
        case .failure(let error):
            let newPublisher = handler(error)
            
            guard let newOperation = newPublisher.result.operation else {
                return
            }
            
            newOperation.completionBlock = { [weak self] in
                switch newPublisher.result.result {
                case .success(let output):
                    self?.result.result = .success(output)
                    
                case .failure(let error):
                    self?.result.result = .failure(error)
                }
                
                newPublisher.queue.operationQueue.cancelAllOperations()
                self?.finish()
            }
            
            newOperation.main()
        }
    }
}

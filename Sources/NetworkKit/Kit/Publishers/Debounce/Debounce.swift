//
//  Debounce.swift
//  NetworkKit
//
//  Created by Raghav Ahuja on 18/11/19.
//  Copyright © 2019 Raghav Ahuja. All rights reserved.
//

import Foundation

public extension NetworkPublishers {
    
    struct Debounce<Upstream: NetworkPublisher>: NetworkPublisher {
        
        public var result: NetworkResult<Output, Failure> {
            upstream.result
        }
        
        public var queue: NetworkQueue {
            upstream.queue
        }
        
        public typealias Output = Upstream.Output
        
        public typealias Failure = Upstream.Failure
        
        /// The publisher that this publisher receives elements from.
        public let upstream: Upstream
        
        public let time: DispatchTime
        
        public init(upstream: Upstream, time: DispatchTime) {
            self.upstream = upstream
            self.time = time
            perform()
        }
        
        private func perform() {
            let operation = DebounceOperation(time: time)
            queue.operations.first?.addDependency(operation)
            addToQueue(operation)
        }
        
        public func cancel() {
            upstream.queue.operationQueue.cancelAllOperations()
        }
    }
}

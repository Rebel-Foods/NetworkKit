//
//  Debounce.swift
//  NetworkKit
//
//  Created by Raghav Ahuja on 18/11/19.
//  Copyright © 2019 Raghav Ahuja. All rights reserved.
//

import Foundation

public extension NetworkPublishers {
    
    struct Debounce<Upstream: NKPublisher>: NKPublisher {
        
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
        
        public let dueTime: DispatchTime
        
        public init(upstream: Upstream, dueTime: DispatchTime) {
            self.upstream = upstream
            self.dueTime = dueTime
            perform()
        }
        
        private func perform() {
            let operation = DebounceOperation(dueTime: dueTime)
            queue.operations.first?.addDependency(operation)
            addToQueue(operation)
        }
        
        public func cancel() {
            upstream.queue.operationQueue.cancelAllOperations()
        }
    }
}

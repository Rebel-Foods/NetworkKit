//
//  Completion.swift
//  NetworkKit
//
//  Created by Raghav Ahuja on 18/11/19.
//  Copyright © 2019 Raghav Ahuja. All rights reserved.
//

import Foundation

extension NKPublishers {
    
    struct Completion<Upstream: NKPublisher>: NetworkCancellable {
        
        /// The publisher that this publisher receives elements from.
        public let upstream: Upstream
        
        /// A closure that returns the result of the upstream publisher.
        public let block: (Result<Upstream.Output, Upstream.Failure>) -> Void
        
        public init(upstream: Upstream, block: @escaping (Result<Upstream.Output, Upstream.Failure>) -> Void) {
            self.upstream = upstream
            self.block = block
            completion()
        }
        
        private func completion() {
            addToQueue {
                self.block(self.upstream.result.result!)
            }
        }
        
        private func addToQueue(_ block: @escaping () -> Void) {
            let op = BaseBlockOperation(request: upstream.queue.request, result: upstream.result, block: block)
            upstream.queue.addOperation(op)
        }
        
        public func cancel() {
            upstream.queue.operationQueue.cancelAllOperations()
        }
    }
}

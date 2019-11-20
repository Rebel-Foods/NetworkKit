//
//  Assign.swift
//  NetworkKit
//
//  Created by Raghav Ahuja on 18/11/19.
//  Copyright © 2019 Raghav Ahuja. All rights reserved.
//

import Foundation

extension NKPublishers {
    
    struct Assign<Root, Upstream: NKPublisher>: NetworkCancellable where Upstream.Failure == Never {
        
        /// The publisher that this publisher receives elements from.
        public let upstream: Upstream
        
        public let root: Root
        
        public let keyPath: ReferenceWritableKeyPath<Root, Upstream.Output>
        
        public init(upstream: Upstream, to keyPath: ReferenceWritableKeyPath<Root, Upstream.Output>, on root: Root) {
            self.upstream = upstream
            self.root = root
            self.keyPath = keyPath
            assign()
        }
        
        private func assign() {
            addToQueue {
                let value = try! self.upstream.result.result.get()
                self.root[keyPath: self.keyPath] = value
            }
        }
        
        private func addToQueue(_ block: @escaping () -> Void) {
            let op = BlockOperation(block: block)
            upstream.queue.addOperation(op)
        }
        
        public func cancel() {
            upstream.queue.operationQueue.cancelAllOperations()
        }
    }
}

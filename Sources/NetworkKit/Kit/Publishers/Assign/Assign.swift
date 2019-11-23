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
        
        /// The object on which to assign the value.
        public let object: Root
        
        /// The key path of the property to assign.
        public let keyPath: ReferenceWritableKeyPath<Root, Upstream.Output>
        
        public init(upstream: Upstream, to keyPath: ReferenceWritableKeyPath<Root, Upstream.Output>, on object: Root) {
            self.upstream = upstream
            self.object = object
            self.keyPath = keyPath
            assign()
        }
        
        private func assign() {
            addToQueue {
                guard let value = try? self.upstream.result.result?.get() else {
                    return
                }
                self.object[keyPath: self.keyPath] = value
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

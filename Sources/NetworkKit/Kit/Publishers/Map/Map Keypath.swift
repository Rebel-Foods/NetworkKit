//
//  Map KeyPath.swift
//  NetworkKit
//
//  Created by Raghav Ahuja on 18/11/19.
//  Copyright © 2019 Raghav Ahuja. All rights reserved.
//

import Foundation

public extension NKPublishers {
    
    /// A publisher that publishes the value of a key path.
    struct MapKeyPath<Upstream: NKPublisher, Output>: NKPublisher {
        
        public var result: NetworkResult<Output, Upstream.Failure>
        
        public var queue: NetworkQueue {
            upstream.queue
        }
        
        public typealias Failure = Upstream.Failure
        
        /// The publisher from which this publisher receives elements.
        public let upstream: Upstream
        
        /// The key path of a property to publish.
        public let keyPath: KeyPath<Upstream.Output, Output>
        
        public init(upstream: Upstream, keyPath: KeyPath<Upstream.Output, Output>) {
            self.upstream = upstream
            self.keyPath = keyPath
            result = .init()
            perform()
        }
        
        private func perform() {
            addToQueue {
                self.map()
            }
        }
        
        private func map() {
            switch upstream.result.result {
            case .success(let output):
                result.result = .success(output[keyPath: keyPath])
                
            case .failure(let error):
                result.result = .failure(error)
            }
        }
    }
    
}

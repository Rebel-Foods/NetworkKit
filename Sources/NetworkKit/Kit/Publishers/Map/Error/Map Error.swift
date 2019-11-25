//
//  Map Error.swift
//  NetworkKit
//
//  Created by Raghav Ahuja on 18/11/19.
//  Copyright © 2019 Raghav Ahuja. All rights reserved.
//

import Foundation

public extension NKPublishers {
    
    struct MapError<Upstream: NKPublisher, MapFailure: Error>: NKPublisher {
        
        public var result: NKResult<Output, Failure>
        
        public var queue: NKQueue {
            upstream.queue
        }
        
        public typealias Output = Upstream.Output
        
        public typealias Failure = MapFailure
        
        /// The publisher that this publisher receives elements from.
        public let upstream: Upstream
        
        /// The closure that transforms elements from the upstream publisher.
        public let transform: (Upstream.Failure) -> MapFailure
        
        public init(upstream: Upstream, transform: @escaping (Upstream.Failure) -> MapFailure) {
            self.upstream = upstream
            self.transform = transform
            result = .init(result: .none)
            perform()
        }
        
        private func perform() {
            addToQueue {
                self.doTransform()
            }
        }
        
        private func doTransform() {
            let upstreamResult = upstream.result.result
            
            switch upstreamResult {
            case .success(let output):
                result.result = .success(output)
                
            case .failure(let error):
                let newError = transform(error)
                result.result = .failure(newError)
                
            case .none:
                result.result = .none
            }
        }
    }
}

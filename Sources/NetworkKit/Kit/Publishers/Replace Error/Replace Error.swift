//
//  Replace Error.swift
//  NetworkKit
//
//  Created by Raghav Ahuja on 18/11/19.
//  Copyright © 2019 Raghav Ahuja. All rights reserved.
//

import Foundation

public extension NKPublishers {
    
    struct ReplaceError<Upstream: NKPublisher>: NKPublisher {
        
        public var result: NKResult<Output, Failure>
        
        public var queue: NKQueue {
            upstream.queue
        }
        
        public typealias Output = Upstream.Output
        
        public typealias Failure = Never
        
        /// The element with which to replace errors from the upstream publisher.
        public let output: Upstream.Output
        
        /// The publisher from which this publisher receives elements.
        public let upstream: Upstream
        
        public init(upstream: Upstream, output: Output) {
            self.upstream = upstream
            self.output = output
            result = .init(result: .success(output))
            perform()
        }
        
        private func perform() {
            addToQueue {
                self.doReplace()
            }
        }
        
        private func doReplace() {
            let upstreamResult = upstream.result.result
            
            switch upstreamResult {
            case .success(let output):
                result.result = .success(output)
                
            case .failure:
                result.result = .success(output)
            }
        }
    }
}

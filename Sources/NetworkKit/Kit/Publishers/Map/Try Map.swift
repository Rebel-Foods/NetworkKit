//
//  Try Map.swift
//  NetworkKit
//
//  Created by Raghav Ahuja on 18/11/19.
//  Copyright © 2019 Raghav Ahuja. All rights reserved.
//

import Foundation

public extension NetworkPublishers {
    
    struct TryMap<Upstream: NKPublisher, MapOutput>: NKPublisher {
        
        public var result: NetworkResult<Output, Failure>
        
        public var queue: NetworkQueue {
            upstream.queue
        }
        
        public typealias Output = MapOutput
        
        public typealias Failure = Upstream.Failure
        
        /// The publisher that this publisher receives elements from.
        public let upstream: Upstream
        
        /// The closure that transforms elements from the upstream publisher.
        public let transform: (Upstream.Output) throws -> Output
        
        public init(upstream: Upstream, transform: @escaping (Upstream.Output) throws -> Output) {
            self.upstream = upstream
            self.transform = transform
            result = .init()
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

                do {
                    let newOutput = try transform(output)
                    result.result = .success(newOutput)
                    
                } catch let tranformError {
                    let error = tranformError as NSError
                    result.result = .failure(NKError(error) as! Upstream.Failure)
                }
                
            case .failure(let error):
                result.result = .failure(error)
            }
        }
    }
}

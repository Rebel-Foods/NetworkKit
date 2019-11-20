//
//  Map KeyPath 2.swift
//  NetworkKit
//
//  Created by Raghav Ahuja on 18/11/19.
//  Copyright © 2019 Raghav Ahuja. All rights reserved.
//

import Foundation

extension NKPublishers {
    
    /// A publisher that publishes the values of two key paths as a tuple.
    public struct MapKeyPath2<Upstream: NKPublisher, Output0, Output1>: NKPublisher {
        
        public var result: NKResult<(Output0, Output1), Upstream.Failure>
        
        public var queue: NKQueue {
            upstream.queue
        }

        public typealias Output = (Output0, Output1)
        
        public typealias Failure = Upstream.Failure

        /// The publisher from which this publisher receives elements.
        public let upstream: Upstream

        /// The key path of a property to publish.
        public let keyPath0: KeyPath<Upstream.Output, Output0>

        /// The key path of a second property to publish.
        public let keyPath1: KeyPath<Upstream.Output, Output1>
        
        public init(upstream: Upstream, keyPath0: KeyPath<Upstream.Output, Output0>, keyPath1: KeyPath<Upstream.Output, Output1>) {
            self.upstream = upstream
            self.keyPath0 = keyPath0
            self.keyPath1 = keyPath1
            
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
                let output1 = output[keyPath: keyPath0]
                let output2 = output[keyPath: keyPath1]
                
                result.result = .success((output1, output2))
                
            case .failure(let error):
                result.result = .failure(error)
            }
        }
    }

}

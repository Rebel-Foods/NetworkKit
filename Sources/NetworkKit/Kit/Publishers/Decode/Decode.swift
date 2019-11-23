//
//  Decode.swift
//  NetworkKit
//
//  Created by Raghav Ahuja on 18/11/19.
//  Copyright © 2019 Raghav Ahuja. All rights reserved.
//

import Foundation

public extension NKPublishers {
    
    struct Decode<Upstream: NKPublisher, Item: Decodable, Decoder: NetworkDecoder>: NKPublisher where Upstream.Output == Decoder.Input {
        
        public var result: NKResult<Output, Failure>
        
        public var queue: NKQueue {
            upstream.queue
        }
        
        public typealias Output = Item
        
        public typealias Failure = NSError
        
        /// The publisher that this publisher receives elements from.
        public let upstream: Upstream
        
        public let decoder: Decoder
        
        public init(upstream: Upstream, decoder: Decoder) {
            self.upstream = upstream
            self.decoder = decoder
            result = .init()
            perform()
        }
        
        public init(upstream: Upstream, jsonKeyDecodingStrategy: JSONDecoder.KeyDecodingStrategy) {
            self.upstream = upstream
            
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = jsonKeyDecodingStrategy
            self.decoder = decoder as! Decoder
            
            result = .init()
            perform()
        }
        
        private func perform() {
            addToQueue {
                self.doDecoding()
            }
        }
        
        private func doDecoding() {
            let upstreamResult = upstream.result.result
            
            switch upstreamResult {
            case .success(let data):
                
                do {
                    let output = try decoder.decode(Item.self, from: data)
                    self.result.result = .success(output)
                    
                } catch {
                    result.result = .failure(error as NSError)
                }
                
            case .failure(let error):
                result.result = .failure(error as NSError)
                    
            case .none:
                result.result = .none
            }
        }
    }
}

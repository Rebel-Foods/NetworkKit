//
//  Map.swift
//  NetworkKit
//
//  Created by Raghav Ahuja on 18/11/19.
//  Copyright © 2019 Raghav Ahuja. All rights reserved.
//

import Foundation

public extension NetworkPublishers {
    
    struct Map<Upstream: NKPublisher, MapOutput>: NKPublisher {
        
        public var result: NetworkResult<Output, Failure>
        
        public var queue: NetworkQueue {
            upstream.queue
        }
        
        public typealias Output = MapOutput
        
        public typealias Failure = Upstream.Failure
        
        /// The publisher that this publisher receives elements from.
        public let upstream: Upstream
        
        /// The closure that transforms elements from the upstream publisher.
        public let transform: (Upstream.Output) -> Output
        
        public init(upstream: Upstream, transform: @escaping (Upstream.Output) -> Output) {
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
                let newOutput = transform(output)
                result.result = .success(newOutput)
                
            case .failure(let error):
                result.result = .failure(error)
                
            }
        }
    }
}



//@available(OSX 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
//extension Publishers {
//
//    /// A publisher that republishes all non-`nil` results of calling a closure with each received element.
//    public struct CompactMap<Upstream, Output> : Publisher where Upstream : Publisher {
//
//        /// The kind of errors this publisher might publish.
//        ///
//        /// Use `Never` if this `Publisher` does not publish errors.
//        public typealias Failure = Upstream.Failure
//
//        /// The publisher from which this publisher receives elements.
//        public let upstream: Upstream
//
//        /// A closure that receives values from the upstream publisher and returns optional values.
//        public let transform: (Upstream.Output) -> Output?
//
//        public init(upstream: Upstream, transform: @escaping (Upstream.Output) -> Output?)
//
//        /// This function is called to attach the specified `Subscriber` to this `Publisher` by `subscribe(_:)`
//        ///
//        /// - SeeAlso: `subscribe(_:)`
//        /// - Parameters:
//        ///     - subscriber: The subscriber to attach to this `Publisher`.
//        ///                   once attached it can begin to receive values.
//        public func receive<S>(subscriber: S) where Output == S.Input, S : Subscriber, Upstream.Failure == S.Failure
//    }
//
//    /// A publisher that republishes all non-`nil` results of calling an error-throwing closure with each received element.
//    public struct TryCompactMap<Upstream, Output> : Publisher where Upstream : Publisher {
//
//        /// The kind of errors this publisher might publish.
//        ///
//        /// Use `Never` if this `Publisher` does not publish errors.
//        public typealias Failure = Error
//
//        /// The publisher from which this publisher receives elements.
//        public let upstream: Upstream
//
//        /// An error-throwing closure that receives values from the upstream publisher and returns optional values.
//        ///
//        /// If this closure throws an error, the publisher fails.
//        public let transform: (Upstream.Output) throws -> Output?
//
//        public init(upstream: Upstream, transform: @escaping (Upstream.Output) throws -> Output?)
//
//        /// This function is called to attach the specified `Subscriber` to this `Publisher` by `subscribe(_:)`
//        ///
//        /// - SeeAlso: `subscribe(_:)`
//        /// - Parameters:
//        ///     - subscriber: The subscriber to attach to this `Publisher`.
//        ///                   once attached it can begin to receive values.
//        public func receive<S>(subscriber: S) where Output == S.Input, S : Subscriber, S.Failure == Publishers.TryCompactMap<Upstream, Output>.Failure
//    }
//}


///// Calls a closure with each received element and publishes any returned optional that has a value.
/////
///// - Parameter transform: A closure that receives a value and returns an optional value.
///// - Returns: A publisher that republishes all non-`nil` results of calling the transform closure.
//public func compactMap<T>(_ transform: @escaping (Self.Output) -> T?) -> Publishers.CompactMap<Self, T>
//
///// Calls an error-throwing closure with each received element and publishes any returned optional that has a value.
/////
///// If the closure throws an error, the publisher cancels the upstream and sends the thrown error to the downstream receiver as a `Failure`.
///// - Parameter transform: an error-throwing closure that receives a value and returns an optional value.
///// - Returns: A publisher that republishes all non-`nil` results of calling the transform closure.
//public func tryCompactMap<T>(_ transform: @escaping (Self.Output) throws -> T?) -> Publishers.TryCompactMap<Self, T>

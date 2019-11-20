//
//  NKPublisher+Methods.swift
//  NetworkKit
//
//  Created by Raghav Ahuja on 18/11/19.
//  Copyright © 2019 Raghav Ahuja. All rights reserved.
//

import Foundation

public extension NKPublisher {
    
    /// Decodes the output from upstream using a specified `NetworkDecoder`.
    /// For example, use `JSONDecoder`.
    /// - Parameter type: Type to decode into.
    /// - Parameter decoder: `NetworkDecoder` for decoding output.
    func decode<Item, Decoder>(type: Item.Type, decoder: Decoder) -> NKPublishers.Decode<Self, Item, Decoder> {
        NKPublishers.Decode(upstream: self, decoder: decoder)
    }
    
    /// Decodes the output from upstream using a specified `JSONDecoder`.
    /// - Parameter type: Type to decode into.
    /// - Parameter jsonKeyDecodingStrategy: JSON Key Decoding Strategy.
    func decode<Item>(type: Item.Type, jsonKeyDecodingStrategy: JSONDecoder.KeyDecodingStrategy) -> NKPublishers.Decode<Self, Item, JSONDecoder> {
        NKPublishers.Decode(upstream: self, jsonKeyDecodingStrategy: jsonKeyDecodingStrategy)
    }
    
    /// Transforms all elements from the upstream publisher with a provided closure.
    ///
    /// - Parameter transform: A closure that takes one element as its parameter and returns a new element.
    /// - Returns: A publisher that uses the provided closure to map elements from the upstream publisher to new elements that it then publishes.
    func map<T>(_ transform: @escaping (Output) -> T) -> NKPublishers.Map<Self, T> {
        NKPublishers.Map(upstream: self, transform: transform)
    }
    
    /// Transforms all elements from the upstream publisher with a provided error-throwing closure.
    ///
    /// If the `transform` closure throws an error, the publisher fails with the thrown error.
    /// - Parameter transform: A closure that takes one element as its parameter and returns a new element.
    /// - Returns: A publisher that uses the provided closure to map elements from the upstream publisher to new elements that it then publishes.
    func tryMap<T>(_ transform: @escaping (Output) throws -> T) -> NKPublishers.TryMap<Self, T> {
        NKPublishers.TryMap(upstream: self, transform: transform)
    }
    
    /// Replaces any errors in the stream with the provided element.
    ///
    /// If the upstream publisher fails with an error, this publisher emits the provided element, then finishes normally.
    /// - Parameter output: An element to emit when the upstream publisher fails.
    /// - Returns: A publisher that replaces an error from the upstream publisher with the provided output element.
    func replaceError(with output: Output) -> NKPublishers.ReplaceError<Self> {
        NKPublishers.ReplaceError(upstream: self, output: output)
    }
    
    /// Publishes elements only after a specified time interval elapses between events.
    ///
    /// Use this operator when you want to wait for a pause in the delivery of events from the upstream publisher. For example, call `debounce` on the publisher from a text field to only receive elements when the user pauses or stops typing. When they start typing again, the `debounce` holds event delivery until the next pause.
    /// - Parameters:
    ///   - dueTime: The time the publisher should wait before publishing an element.
    /// - Returns: A publisher that publishes events only after a specified time elapses.
    func debounce(_ dueTime: DispatchTimeInterval) -> NKPublishers.Debounce<Self> {
        NKPublishers.Debounce(upstream: self, dueTime: .now() + dueTime)
    }
    
    /// Publishes elements only after a specified time interval elapses between events.
    ///
    /// Use this operator when you want to wait for a pause in the delivery of events from the upstream publisher. For example, call `debounce` on the publisher from a text field to only receive elements when the user pauses or stops typing. When they start typing again, the `debounce` holds event delivery until the next pause.
    /// - Parameters:
    ///   - dueTime: The time the publisher should wait before publishing an element.
    ///   - scheduler: The scheduler on which this publisher delivers elements
    func debounce(_ dueTime: DispatchTime) -> NKPublishers.Debounce<Self> {
        NKPublishers.Debounce(upstream: self, dueTime: dueTime)
    }
    
    /// Returns a publisher that publishes the value of a key path.
    ///
    /// - Parameter keyPath: The key path of a property on `Output`
    /// - Returns: A publisher that publishes the value of the key path.
    func map<T>(_ keyPath: KeyPath<Self.Output, T>) -> NKPublishers.MapKeyPath<Self, T> {
        NKPublishers.MapKeyPath(upstream: self, keyPath: keyPath)
    }
    
    /// Returns a publisher that publishes the values of two key paths as a tuple.
    ///
    /// - Parameters:
    ///   - keyPath0: The key path of a property on `Output`
    ///   - keyPath1: The key path of another property on `Output`
    /// - Returns: A publisher that publishes the values of two key paths as a tuple.
    func map<T0, T1>(_ keyPath0: KeyPath<Self.Output, T0>, _ keyPath1: KeyPath<Self.Output, T1>) -> NKPublishers.MapKeyPath2<Self, T0, T1> {
        NKPublishers.MapKeyPath2(upstream: self, keyPath0: keyPath0, keyPath1: keyPath1)
    }
    
    /// Handles errors from an upstream publisher by replacing it with another publisher.
    ///
    /// The following example replaces any error from the upstream publisher and replaces the upstream with a `Just` publisher. This continues the stream by publishing a single value and completing normally.
    /// ```
    /// enum SimpleError: Error { case error }
    /// let errorPublisher = (0..<10).publisher.tryMap { v -> Int in
    ///     if v < 5 {
    ///         return v
    ///     } else {
    ///         throw SimpleError.error
    ///     }
    /// }
    ///
    /// let noErrorPublisher = errorPublisher.catch { _ in
    ///     return Just(100)
    /// }
    /// ```
    /// Backpressure note: This publisher passes through `request` and `cancel` to the upstream. After receiving an error, the publisher sends sends any unfulfilled demand to the new `Publisher`.
    /// - Parameter handler: A closure that accepts the upstream failure as input and returns a publisher to replace the upstream publisher.
    /// - Returns: A publisher that handles errors from an upstream publisher by replacing the failed publisher with another publisher.
    func `catch`<P: NKPublisher>(_ handler: @escaping (Self.Failure) -> P) -> NKPublishers.Catch<Self, P> where Self.Output == P.Output {
        NKPublishers.Catch(upstream: self, handler: handler)
    }
    
    /// Handles errors from an upstream publisher by either replacing it with another publisher or `throw`ing  a new error.
    ///
    /// - Parameter handler: A `throw`ing closure that accepts the upstream failure as input and returns a publisher to replace the upstream publisher or if an error is thrown will send the error downstream.
    /// - Returns: A publisher that handles errors from an upstream publisher by replacing the failed publisher with another publisher.
    func tryCatch<P: NKPublisher>(_ handler: @escaping (Self.Failure) throws -> P) -> NKPublishers.TryCatch<Self, P> where Self.Output == P.Output {
        NKPublishers.TryCatch(upstream: self, handler: handler)
    }
}

public extension NKPublisher where Self.Output == NetworkKit.Output, Self.Failure == NetworkKit.Failure {
    
    /// Validates Network call response with provided acceptable status codes.
    /// - Parameter acceptableStatusCodes: Acceptable HTTP Status codes for the network call. Default value is `Array(200 < 300)`.
    /// - Parameter checkForErrorModel: If publisher should check for custom error model to decode.
    /// - Returns: A publisher that validates response from an upstream publisher.
    func validate(acceptableStatusCodes: [Int] = [], checkForErrorModel: Bool = true) -> NKPublishers.Validate<Self> {
        NKPublishers.Validate(upstream: self, shouldCheckForErrorModel: checkForErrorModel, acceptableStatusCodes: acceptableStatusCodes)
    }
}

public extension NKPublisher {
    
    /// Attaches a subscriber with closure-based behavior.
    ///
    /// This method creates the subscriber and immediately requests an unlimited number of values, prior to returning the subscriber.
    /// - parameter receiveComplete: The closure to execute on completion.
    /// - parameter receiveValue: The closure to execute on receipt of a value.
    /// - Returns: A cancellable instance; used when you end assignment of the received value. Deallocation of the result will tear down the subscription stream.
    func completion(_ block: @escaping (Result<Output, Failure>) -> Void) -> NetworkCancellable {
        NKPublishers.Completion(upstream: self, block: block)
    }
}

public extension NKPublisher where Self.Failure == Never {
    
    /// Assigns each element from a Publisher to a property on an object.
    ///
    /// - Parameters:
    ///   - keyPath: The key path of the property to assign.
    ///   - object: The object on which to assign the value.
    /// - Returns: A cancellable instance; used when you end assignment of the received value. Deallocation of the result will tear down the subscription stream.
    func assign<Root>(to keyPath: ReferenceWritableKeyPath<Root, Self.Output>, on root: Root) -> NetworkCancellable {
        NKPublishers.Assign(upstream: self, to: keyPath, on: root)
    }
}

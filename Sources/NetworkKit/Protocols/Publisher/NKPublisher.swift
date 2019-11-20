//
//  NKPublisher.swift
//  NetworkKit
//
//  Created by Raghav Ahuja on 18/11/19.
//  Copyright © 2019 Raghav Ahuja. All rights reserved.
//

import Foundation

public protocol NKPublisher {

    /// The kind of values published by this publisher.
    associatedtype Output
    
    /// The kind of errors this publisher might publish.
    ///
    /// Use `Never` if this `Publisher` does not publish errors.
    associatedtype Failure: NetworkError
    
    var result: NetworkResult<Output, Failure> { get }
    
    var queue: NKQueue { get }
}

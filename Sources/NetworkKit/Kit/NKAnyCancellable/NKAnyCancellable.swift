//
//  NKAnyCancellable.swift
//  NetworkKit
//
//  Created by Raghav Ahuja on 25/11/19.
//  Copyright © 2019 Raghav Ahuja. All rights reserved.
//

import Foundation

public class NKAnyCancellable: NKCancellable {
    
    let block: () -> Void
    
    /// Initializes the cancellable object with the given cancel-time closure.
    ///
    /// - Parameter cancel: A closure that the `cancel()` method executes.
    public init(cancel: @escaping () -> Void) {
        block = cancel
    }
    
    public init<C: NKCancellable>(_ canceller: C) {
        block = canceller.cancel
    }
    
    deinit {
        cancel()
    }
    
    public func cancel() {
        block()
    }
}

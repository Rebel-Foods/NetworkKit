//
//  NKQueue.swift
//  NetworkKit
//
//  Created by Raghav Ahuja on 18/11/19.
//  Copyright © 2019 Raghav Ahuja. All rights reserved.
//

import Foundation

public final class NKQueue {
    
    /// A queue that regulates the execution of operations.
    /// It is a serial queue, that has `quality of service` of `utility`.
    let operationQueue: OperationQueue
    
    let request: URLRequest?
    
    let apiName: String
    
    var operations: [Operation] {
        operationQueue.operations
    }
    
    init(operationQueue: OperationQueue, request: URLRequest?, apiName: String?) {
        self.operationQueue = operationQueue
        self.request = request
        self.apiName = apiName ?? request?.url?.absoluteString ?? "nil"
    }
    
    func addOperation(_ op: Operation) {
        operationQueue.addOperation(op)
    }
    
    func addOperation(_ block: @escaping () -> Void) {
        operationQueue.addOperation(block)
    }
}

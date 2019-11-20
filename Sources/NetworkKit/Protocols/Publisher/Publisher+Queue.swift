//
//  Publisher+Queue.swift
//  NetworkKit
//
//  Created by Raghav Ahuja on 18/11/19.
//  Copyright © 2019 Raghav Ahuja. All rights reserved.
//

import Foundation

extension NetworkPublisher {
    
    func addToQueue(isSuspended: Bool = false, _ block: @escaping () -> Void) {
        let op = BlockOperation(block: block)
        result.operation = op
        queue.addOperation(op)
        queue(isSuspended: isSuspended)
    }
    
    func addToQueue(isSuspended: Bool = false, _ op: Operation) {
        result.operation = op
        queue.addOperation(op)
        queue(isSuspended: isSuspended)
    }
    
    func queue(isSuspended: Bool) {
        if queue.operationQueue.isSuspended != isSuspended {
            queue.operationQueue.isSuspended = isSuspended
        }
    }
}

//
//  NKPublisher+Queue.swift
//  NetworkKit
//
//  Created by Raghav Ahuja on 18/11/19.
//  Copyright © 2019 Raghav Ahuja. All rights reserved.
//

import Foundation

extension NKPublisher {
    
    func addToQueue(isSuspended: Bool = false, _ block: @escaping () -> Void) {
        let op = BaseBlockOperation(request: queue.request, result: result, block: block)
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
        if queue.isSuspended != isSuspended {
            queue.isSuspended = isSuspended
        }
    }
}

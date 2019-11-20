//
//  Debounce Operation.swift
//  NetworkKit
//
//  Created by Raghav Ahuja on 18/11/19.
//  Copyright © 2019 Raghav Ahuja. All rights reserved.
//

import Foundation

class DebounceOperation: AsynchronousOperation {
    
    let dueTime: DispatchTime
    
    init(dueTime: DispatchTime) {
        self.dueTime = dueTime
        super.init()
        queuePriority = .veryHigh
    }
    
    override func main() {
        DispatchQueue.global(qos: .utility).asyncAfter(deadline: dueTime) { [weak self] in
            self?.finish()
        }
    }
}

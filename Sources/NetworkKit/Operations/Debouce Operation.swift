//
//  Debounce Operation.swift
//  NetworkKit
//
//  Created by Raghav Ahuja on 18/11/19.
//  Copyright © 2019 Raghav Ahuja. All rights reserved.
//

import Foundation

class DebounceOperation: AsynchronousOperation {
    
    let time: DispatchTime
    
    init(time: DispatchTime) {
        self.time = time
        super.init()
        queuePriority = .veryHigh
    }
    
    override func main() {
        DispatchQueue.global(qos: .utility).asyncAfter(deadline: time) { [weak self] in
            self?.finish()
        }
    }
}

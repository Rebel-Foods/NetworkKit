//
//  Debounce Operation.swift
//  NetworkKit
//
//  Created by Raghav Ahuja on 18/11/19.
//  Copyright © 2019 Raghav Ahuja. All rights reserved.
//

import Foundation

final class DebounceOperation<Output, Failure: Error>: AsynchronousOperation {
    
    let dueTime: DispatchTime
    let result: NKResult<Output, Failure>
    let url: URL?
    
    init(result: NKResult<Output, Failure>, url: URL?, dueTime: DispatchTime) {
        self.result = result
        self.url = url
        self.dueTime = dueTime
        super.init()
        queuePriority = .veryHigh
    }
    
    override func main() {
        DispatchQueue.global(qos: .utility).asyncAfter(deadline: dueTime) { [weak self] in
            self?.finish()
        }
    }
    
    override func cancel() {
        let error = NSError.cancelled(for: url)
        result.result = .failure(error as! Failure)
        super.cancel()
    }
}

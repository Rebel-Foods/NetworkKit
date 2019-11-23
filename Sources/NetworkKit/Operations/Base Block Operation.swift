//
//  Base Block Operation.swift
//  NetworkKit
//
//  Created by Raghav Ahuja on 23/11/19.
//  Copyright © 2019 Raghav Ahuja. All rights reserved.
//

import Foundation

class BaseBlockOperation<Output, Failure: Error>: BlockOperation {
    
    var result: NKResult<Output, Failure>
    var request: URLRequest?
    
    init(request: URLRequest?, result: NKResult<Output, Failure>, block: @escaping () -> Void) {
        self.request = request
        self.result = result
        super.init()
        addExecutionBlock(block)
    }
    
    override func cancel() {
        let error = NSError.cancelled(for: request?.url)
        result.result = .failure(error as! Failure)
        super.cancel()
    }
}

//
//  NKResult.swift
//  NetworkKit
//
//  Created by Raghav Ahuja on 18/11/19.
//  Copyright © 2019 Raghav Ahuja. All rights reserved.
//

import Foundation

public final class NKResult<Output, Failure: NetworkError> {
    
    var result: Result<Output, Failure>
    
    var operation: Operation?
    
    init(result: Result<Output, Failure>) {
        self.result = result
    }
    
    init() {
        let error = NKError.notStarted(for: nil)
        result = .failure(error as! Failure)
    }
}

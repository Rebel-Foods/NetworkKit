//
//  Replace Empty Operation.swift
//  NetworkKit
//
//  Created by Raghav Ahuja on 26/11/19.
//  Copyright © 2019 Raghav Ahuja. All rights reserved.
//

import Foundation

final class ReplaceEmptyOperation<Upstream: NKPublisher>: Operation {

    typealias Output = Upstream.Output
    
    private let upstream: Upstream
    
    private let output: Output
    
    private let result: NKResult<Output, Never>
    
    init(upstream: Upstream, output: Output, result: NKResult<Output, Never>) {
        self.upstream = upstream
        self.output = output
        self.result = result
    }
    
    override func main() {
        let upstreamResult = upstream.result.result
        
        switch upstreamResult {
        case .success(let output):
            result.result = .success(output)
            
        case .failure, .none:
            result.result = .success(output)
        }
    }
    
    override func cancel() {
        result.result = .success(output)
        super.cancel()
    }
}

//
//  Catch Operation.swift
//  NetworkKit
//
//  Created by Raghav Ahuja on 21/11/19.
//  Copyright © 2019 Raghav Ahuja. All rights reserved.
//

import Foundation

final class CatchOperation<Upstream: NKPublisher, NewPublisher: NKPublisher>: AsynchronousOperation where Upstream.Output == NewPublisher.Output {

    typealias Output = Upstream.Output

    typealias Failure = NewPublisher.Failure

    /// The publisher that this publisher receives elements from.
    private let upstream: Upstream
    
    private var result: NKResult<Output, Failure>

    /// A closure that accepts the upstream failure as input and returns a publisher to replace the upstream publisher.
    private let handler: (Upstream.Failure) -> NewPublisher
    
    private var newOperation: Operation?
    
    init(upstream: Upstream, handler: @escaping (Upstream.Failure) -> NewPublisher, result: NKResult<Output, Failure>) {
        self.upstream = upstream
        self.handler = handler
        self.result = result
    }
    
    override func main() {
        guard !isCancelled else {
            return
        }
        
        switch upstream.result.result {
        case .success(let output):
            result.result = .success(output)
            
        case .failure(let error):
            let newPublisher = handler(error)
            
            guard let newOperation = newPublisher.result.operation else {
                return
            }
            
            self.newOperation = newOperation
            
            newOperation.completionBlock = { [weak self] in
                guard !(self?.isCancelled ?? true) else {
                    return
                }
                
                switch newPublisher.result.result! {
                case .success(let output):
                    self?.result.result = .success(output)
                    
                case .failure(let error):
                    self?.result.result = .failure(error)
                }
                
                newPublisher.queue.cancelAllOperations()
                self?.finish()
            }
            
            newOperation.main()
            
        case .none:
            result.result = .none
        }
    }
    
    override func cancel() {
        newOperation?.cancel()
        let error = NSError.cancelled(for: upstream.queue.request?.url)
        result.result = .failure(error as! Failure)
        super.cancel()
    }
}

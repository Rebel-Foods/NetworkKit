//
//  TryCatch Operation.swift
//  NetworkKit
//
//  Created by Raghav Ahuja on 21/11/19.
//  Copyright © 2019 Raghav Ahuja. All rights reserved.
//

import Foundation

final class TryCatchOperation<Upstream: NKPublisher, NewPublisher: NKPublisher>: AsynchronousOperation where Upstream.Output == NewPublisher.Output {
    
    public typealias Output = Upstream.Output

    public typealias Failure = NewPublisher.Failure

    /// The publisher that this publisher receives elements from.
    private let upstream: Upstream
    
    private var result: NKResult<Output, Failure>

    /// A closure that accepts the upstream failure as input and returns a publisher to replace the upstream publisher.
    private let handler: (Upstream.Failure) throws -> NewPublisher
    
    public init(upstream: Upstream, handler: @escaping (Upstream.Failure) throws -> NewPublisher, result: NKResult<Output, Failure>) {
        self.upstream = upstream
        self.handler = handler
        self.result = result
    }
    
    private var newOperation: Operation?
    
    override func main() {
        switch upstream.result.result {
        case .success(let output):
            result.result = .success(output)
            finish()
            
        case .failure(let error):
            do {
                let newPublisher = try handler(error)
                
                guard let newOperation = newPublisher.result.operation else {
                    let failError = NSError.unkown()
                    result.result = .failure(failError as! Failure)
                    return
                }
                
                self.newOperation = newOperation
                
                newOperation.completionBlock = { [weak self] in
                    switch newPublisher.result.result! {
                    case .success(let output):
                        self?.result.result = .success(output)
                        
                    case .failure(let error):
                        self?.result.result = .failure(error)
                    }
                    
                    newPublisher.queue.operationQueue.cancelAllOperations()
                    self?.finish()
                }
                
                newOperation.main()
                
            } catch {
                let error = error as NSError
                result.result = .failure(error as! Failure)
                finish()
            }
                
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

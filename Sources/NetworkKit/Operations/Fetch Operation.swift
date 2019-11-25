//
//  Fetch Operation.swift
//  NetworkKit
//
//  Created by Raghav Ahuja on 15/10/19.
//  Copyright © 2019 Raghav Ahuja. All rights reserved.
//

import Foundation

final class FetchOperation: AsynchronousOperation {
    
    private let result: NKResult<NetworkTask.Output, NetworkTask.Failure>?
    
    private let request: URLRequest?
    
    private let session: URLSession
    
    var task: URLSessionDataTask?
    
    init(session: URLSession, request: URLRequest?, result: NKResult<NetworkTask.Output, NetworkTask.Failure>?) {
        self.session = session
        self.request = request
        self.result = result
        super.init()
        
        queuePriority = .high
    }
    
    override func main() {
        guard !isCancelled else {
            return
        }
        
        guard let request = request else {
            result?.result = .failure(NSError.unsupportedURL(for: nil))
            finish()
            return
        }
        
        task = session.dataTask(with: request) { [weak self] (data, response, error) in
            if let error = error as NSError? {
                self?.result?.result = .failure(error)
            } else if let response = response as? HTTPURLResponse, let data = data {
                self?.result?.result = .success((data, response))
            }
            
            self?.finish()
        }
            
        task?.resume()
    }
    
    override func cancel() {
        result?.result = .failure(NSError.cancelled(for: request?.url))
        task?.cancel()
        super.cancel()
    }
}

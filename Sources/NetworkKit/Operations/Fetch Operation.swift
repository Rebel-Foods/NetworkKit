//
//  Fetch Operation.swift
//  NetworkKit
//
//  Created by Raghav Ahuja on 15/10/19.
//  Copyright © 2019 Raghav Ahuja. All rights reserved.
//

import Foundation

class FetchOperation: AsynchronousOperation {
    
    private let result: NetworkResult<NetworkKit.Output, NetworkKit.Failure>?
    private let request: URLRequest?
    
    var task: URLSessionDataTask?
    
    init(request: URLRequest?, result: NetworkResult<NetworkKit.Output, NetworkKit.Failure>?) {
        self.request = request
        self.result = result
        super.init()
        
        queuePriority = .high
    }
    
    override func main() {
        let session = SessionManager.shared.session
        
        guard let request = request else {
            result?.result = .failure(NKError.unsupportedURL(for: nil))
            finish()
            return
        }
        
        task = session.dataTask(with: request) { [weak self] (data, response, error) in
            if let error = error as NSError? {
                self?.result?.result = .failure(NKError(error))
            } else if let response = response as? HTTPURLResponse, let data = data {
                self?.result?.result = .success((data, response))
            }
            
            self?.finish()
        }
            
        task?.resume()
    }
}

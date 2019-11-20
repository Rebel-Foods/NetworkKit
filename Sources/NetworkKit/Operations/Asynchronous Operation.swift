//
//  Asynchronous Operation.swift
//  NetworkKit
//
//  Created by Raghav Ahuja on 15/10/19.
//  Copyright © 2019 Raghav Ahuja. All rights reserved.
//

import Foundation

class AsynchronousOperation: Operation {
    override var isAsynchronous: Bool {
        return true
    }

    private var _isFinished: Bool = false
    override var isFinished: Bool {
        get {
            return _isFinished
        } set {
            willChangeValue(forKey: "isFinished")
            _isFinished = newValue
            didChangeValue(forKey: "isFinished")
        }
    }

    private var _isExecuting: Bool = false
    override var isExecuting: Bool {
        get {
            return _isExecuting
        } set {
            willChangeValue(forKey: "isExecuting")
            _isExecuting = newValue
            didChangeValue(forKey: "isExecuting")
        }
    }

    override func start() {
        guard !isCancelled else {
            return
        }
        isExecuting = true
        main()
    }

    override func main() {
        fatalError("Implement in sublcass to perform task")
    }

    func finish() {
        isExecuting = false
        isFinished = true
    }
}

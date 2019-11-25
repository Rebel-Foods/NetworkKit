//
//  Assign Operation.swift
//  NetworkKit
//
//  Created by Raghav Ahuja on 25/11/19.
//  Copyright © 2019 Raghav Ahuja. All rights reserved.
//

import Foundation

final class AssignOperation<Upstream: NKPublisher, Root>: Operation where Upstream.Failure == Never {

    let upstrem: Upstream
    let keypath: ReferenceWritableKeyPath<Root, Upstream.Output>
    let object: Root
    
    var updatedValue = false
    
    init(upstrem: Upstream, keypath: ReferenceWritableKeyPath<Root, Upstream.Output>, object: Root) {
        self.upstrem = upstrem
        self.keypath = keypath
        self.object = object
    }
    
    override func main() {
        object[keyPath: keypath] = try! upstrem.result.result!.get()
        updatedValue = true
    }
    
    override func cancel() {
        super.cancel()
        if !updatedValue {
            main()
        }
    }
}

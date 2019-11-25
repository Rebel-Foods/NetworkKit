//
//  NKCancellable.swift
//  NetworkKit
//
//  Created by Raghav Ahuja on 18/11/19.
//  Copyright © 2019 Raghav Ahuja. All rights reserved.
//

import Foundation

public protocol NKCancellable {
    
    /// Cancel the activity.
    func cancel()
}

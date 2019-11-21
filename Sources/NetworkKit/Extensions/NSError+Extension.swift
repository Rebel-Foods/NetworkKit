//
//  NSError+Extension.swift
//  NetworkKit
//
//  Created by Raghav Ahuja on 21/11/19.
//  Copyright © 2019 Raghav Ahuja. All rights reserved.
//

import Foundation

extension NSError: NetworkError {
    public var errorCode: Int {
        code
    }
}

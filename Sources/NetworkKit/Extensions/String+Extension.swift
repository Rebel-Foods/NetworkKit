//
//  String+Extension.swift
//  NetworkKit
//
//  Created by Raghav Ahuja on 15/10/19.
//  Copyright © 2019 Raghav Ahuja. All rights reserved.
//

import Foundation

extension String.StringInterpolation {
    
    mutating func appendInterpolation(_ value: Environment) {
        appendInterpolation(value.value)
    }
}

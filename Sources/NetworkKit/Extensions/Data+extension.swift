//
//  Data+Extension.swift
//  NetworkKit
//
//  Created by Raghav Ahuja on 15/10/19.
//  Copyright © 2019 Raghav Ahuja. All rights reserved.
//

import Foundation

extension Data {
    
    var debugDescription: String {
        return String(data: self, encoding: .utf8) ?? "nil"
    }
}

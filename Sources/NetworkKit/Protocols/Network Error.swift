//
//  Network Error.swift
//  NetworkKit
//
//  Created by Raghav Ahuja on 21/11/19.
//  Copyright © 2019 Raghav Ahuja. All rights reserved.
//

import Foundation

public protocol NetworkError: LocalizedError {
    var errorCode: Int { get }
}

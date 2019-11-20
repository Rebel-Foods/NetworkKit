//
//  Never+Extension.swift
//  NetworkKit
//
//  Created by Raghav Ahuja on 18/11/19.
//  Copyright © 2019 Raghav Ahuja. All rights reserved.
//

import Foundation

extension Never: NetworkError {
    
    public var errorCode: Int { -150716 }
}

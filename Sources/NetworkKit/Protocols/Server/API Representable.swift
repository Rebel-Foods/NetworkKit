//
//  API Representable.swift
//  NetworkKit
//
//  Created by Raghav Ahuja on 15/10/19.
//  Copyright © 2019 Raghav Ahuja. All rights reserved.
//

import Foundation

//MARK:- API Type
public protocol APIRepresentable {
    
    /// Sub URL for API Type. It may include server environment for the api, it can be `current` environment.
    var subUrl: String { get }
    
    /// EndPoint for API Type.
    var endPoint: String { get }
}

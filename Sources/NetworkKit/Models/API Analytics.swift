//
//  APIAnalytics.swift
//  NetworkKit
//
//  Created by Raghav Ahuja on 15/10/19.
//  Copyright © 2019 Raghav Ahuja. All rights reserved.
//

import Foundation

public struct APIAnalytics {
    
    public let apiName: String
    public let urlString: String
    public let totalTime: TimeInterval
    public let errorCode: Int?
    public let errorMessage: String?
}

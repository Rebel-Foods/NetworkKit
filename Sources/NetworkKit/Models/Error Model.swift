//
//  ErrorModel.swift
//  NetworkKit
//
//  Created by Raghav Ahuja on 15/10/19.
//  Copyright © 2019 Raghav Ahuja. All rights reserved.
//

import Foundation

// MARK: - ErrorModel
public struct ErrorModel: Codable {
    public let businessCode: Int?
    public let errorCode: Int?
    public let message: String?
    public let status: String?
    
    public var code: Int? {
        return businessCode ?? errorCode
    }
    
    public enum CodingKeys: String, CodingKey {
        case businessCode = "business_error_code"
        case errorCode = "error_code"
        case message
        case status
    }
}

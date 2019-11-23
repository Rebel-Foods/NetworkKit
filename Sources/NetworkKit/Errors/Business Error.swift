//
//  BusinessError.swift
//  NetworkKit
//
//  Created by Raghav Ahuja on 15/10/19.
//  Copyright © 2019 Raghav Ahuja. All rights reserved.
//

import Foundation

/// Personal / Business / Server Errors
enum BusinessError: LocalizedError {
    
    case errorModel(ErrorModel, Int)
    
    var localizedDescription: String {
        switch self {
        case .errorModel(let model, _):
            return model.message ?? ""
        }
    }
    
    var errorCode: Int {
        switch self {
        case .errorModel(let model, let httpStatusCode):
            return model.code ?? httpStatusCode
        }
    }
}

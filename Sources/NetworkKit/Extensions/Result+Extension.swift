//
//  Result+Extension.swift
//  NetworkKit
//
//  Created by Raghav Ahuja on 15/10/19.
//  Copyright © 2019 Raghav Ahuja. All rights reserved.
//

import Foundation

extension Result where Failure: Error {
    
    func getError() -> Failure? {
        switch self {
        case .success:
            return nil
            
        case .failure(let error):
            return error
        }
    }
}

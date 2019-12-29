//
//  Set+Extension.swift
//  NetworkKit
//
//  Created by Raghav Ahuja on 15/10/19.
//  Copyright © 2019 Raghav Ahuja. All rights reserved.
//

import Foundation

extension Set where Element == URLQueryItem {
    
    mutating func addURLQuery(query urlQuery: URLQuery?) {
        if let urlQuery = urlQuery {
            for query in urlQuery {
                let queryItem = URLQueryItem(name: query.key, value: query.value)
                if !self.contains(queryItem) {
                    insert(queryItem)
                }
            }
        }
    }
    
    var toDictionary: URLQuery {
        let params = Dictionary(uniqueKeysWithValues: self.map { ($0.name, $0.value) })
        return params
    }
}

//
//  Set+Extension.swift
//  NetworkKit
//
//  Created by Raghav Ahuja on 15/10/19.
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
}

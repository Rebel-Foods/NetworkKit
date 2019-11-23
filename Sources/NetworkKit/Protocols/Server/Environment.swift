//
//  Environment.swift
//  NetworkKit
//
//  Created by Raghav Ahuja on 15/10/19.
//  Copyright © 2019 Raghav Ahuja. All rights reserved.
//

import Foundation

/**
 Server Environment.
 
 ```
 let url = "https://api-staging.example.com/v1/users/all"
 // `staging` is Server Environment.
 ```
 
 It has a `current` property for maintaining the server environment.
 
 To update the `current` environment, use `NetworkConfiguration.updateEnvironment(:_)`.
 
 In `DEBUG` mode, it persists the `current` value in `UserDefaults`.
 */
public struct Environment: Hashable, Equatable {
    
    /// String value of the environment
    public let value: String
    
    public init(value: String) {
        self.value = value
    }
    
    public internal(set) static var current: Environment = .none
    
    public static let none      = Environment(value: "")
    public static let staging   = Environment(value: "staging")
    public static let dev       = Environment(value: "dev")
}

//
//  APIManager.swift
//  NetworkKit
//
//  Created by Raghav Ahuja on 15/10/19.
//  Copyright © 2019 Raghav Ahuja. All rights reserved.
//

import Foundation

// MARK: - Session Manager
final public class SessionManager: NetworkConfiguration {
    
    public static let shared = SessionManager()
    
    private init() {
        super.init(configuration: NetworkConfiguration.defaultConfiguration)
        
        #if DEBUG
        if let environmentValue = UserDefaults.standard.value(forKey: "api_environment") as? String, !environmentValue.isEmpty {
            Environment.current = Environment(value: environmentValue)
        } else {
            Environment.current = .none
        }
        #else
        Environment.current = .none
        #endif
    }
}

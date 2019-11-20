//
//  DebugLogging.swift
//  NetworkKit
//
//  Created by Raghav Ahuja on 15/10/19.
//  Copyright © 2019 Raghav Ahuja. All rights reserved.
//

import Foundation

typealias DebugPrint = PilotDebugLogs

/// Allows Logs to be Printed in Debug Console.
public struct PilotDebugLogs {
    
    /// Enabled Network debug logs to be printed in debug console.
    /// Default value is `true`
    public static var isEnabled = true
    
    // MARK: - DEBUG LOGS HANDLER
    
    /// Writes the textual representations of the given items into the standard output.
    /// - Parameter value: String to be printed on console.
    /// - Parameter flag: If the value should be printed on console
    static func print(_ value: String, shouldPrint flag: Bool = true) {
        if DebugPrint.isEnabled, flag {
            Swift.print(value)
        }
    }
    
    static func logAPIRequest(request: URLRequest, apiName: String?) {
        print(
            """
            ------------------------------------------------------------
            API Call Request for:
            Name: \(apiName ?? "nil")
            \(request.debugDescription)
            
            """
        )
    }
}

//
//  OSLog+Extension.swift
//  NetworkKit
//
//  Created by Raghav Ahuja on 02/05/20.
//

import Foundation
import os.log

extension OSLog {
    
    @available(macOS 10.12, iOS 10.0, watchOS 3.0, tvOS 10.0, *)
    private static let _imageSession = OSLog(subsystem: Bundle.main.bundleIdentifier ?? "Application", category: "NetworkKit")
    
    @available(macOS 10.12, iOS 10.0, watchOS 3.0, tvOS 10.0, *)
    static var imageSession: OSLog {
        NKImageSession.shared.isLoggingEnabled ? _imageSession : .disabled
    }
}

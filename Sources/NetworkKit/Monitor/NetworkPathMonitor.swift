//
//  NetworkPathMonitor.swift
//  NetworkKit
//
//  Created by Raghav Ahuja on 21/04/20.
//

/// A class that allows monitoring of internet availability and connection type.
public class NetworkPathMonitor {
    
    /// Shared instance for monitoring network.
    ///
    /// macOS 10.14, iOS 12.0, tvOS 12.0, watchOS 5.0 and later will never return `nil`.
    public static let shared: NetworkMonitorType? = {
        if #available(macOS 10.14, iOS 12.0, tvOS 12.0, watchOS 5.0, *) {
            return _NWNetworkMonitor.default
        } else {
            #if os(watchOS)
            return nil
            #else
            return _SCNetworkMonitor.default
            #endif
        }
    }()
}

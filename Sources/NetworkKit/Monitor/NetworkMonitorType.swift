//
//  NetworkMonitorType.swift
//  NetworkKit
//
//  Created by Raghav Ahuja on 21/04/20.
//

public protocol NetworkMonitorType: class {
    
    typealias NetworkPathHandler = (NetworkPath) -> Void
    
    /// The currently available network path observed by the path monitor.
    var currentPath: NetworkPath { get }
    
    /// Flag which tells if network is being monitored or not.
    var isEnabled: Bool { get }
    
    /// Start monitoring network changes.
    /// - Parameter handler: A handler that receives network updates.
    func startMonitoring(handler: NetworkPathHandler?)
    
    /// Stop monitoring network changes.
    func stopMonitoring()
}

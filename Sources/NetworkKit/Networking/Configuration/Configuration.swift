//
//  NKConfiguration.swift
//  NetworkKit
//
//  Created by Raghav Ahuja on 15/10/19.
//  Copyright © 2019 Raghav Ahuja. All rights reserved.
//

import Foundation

// MARK: - NKCONFIGURATION

/// A Class that coordinates a group of related network data transfer tasks.
open class NKConfiguration {
    
    /// Enables Logging for this session.
    /// Default value is `true`.
    open var enableLogs: Bool {
        get {
            logger.isLoggingEnabled
        } set {
            logger.isLoggingEnabled = newValue
        }
    }
    
    var logger = NKLogger()
    
    /// Should allow logging for all sessions.
    /// Default value is `false`.
    public static var allowLoggingOnAllSessions: Bool = true
    
    /// Should empty cache before application terminates.
    /// Default value is `true`.
    open var emptyCacheOnAppTerminate: Bool
    
    /// Should empty cache before application terminates.
    /// Default value is `false`.
    public static var emptyCacheOnAppTerminateOnAllSessions: Bool = false
    
    /// URL Cache for a URLSession
    public let urlCache: URLCache?
    
    /// An object that coordinates a group of related network data transfer tasks.
    public let session: URLSession
    
    /// ACCEPTABLE STATUS CODES
    open var acceptableStatusCodes: [Int] = Array(200 ..< 300)
    
    /// A default session configuration object.
    public static var defaultConfiguration: URLSessionConfiguration = {
        let configuration: URLSessionConfiguration = .default
        
        configuration.requestCachePolicy = .useProtocolCachePolicy
        if #available(iOS 11.0, watchOS 4.0, tvOS 11.0, macOS 10.13, *) {
            configuration.waitsForConnectivity = true
        }
        configuration.networkServiceType = .responsiveData
        configuration.timeoutIntervalForRequest = TimeInterval(integerLiteral: 20)
        configuration.timeoutIntervalForResource = TimeInterval(integerLiteral: 20)
        
        return configuration
    }()
    
    /// Inititalises Manager with `defaultURLSessionConfiguration` Configuration.
    public init(useDefaultCache: Bool, requestCachePolicy: URLRequest.CachePolicy = .useProtocolCachePolicy, cacheDiskPath diskPath: String? = nil) {
        let configuration = NKConfiguration.defaultConfiguration
        configuration.requestCachePolicy = requestCachePolicy
        
        if useDefaultCache {
            if #available(iOS 13.0, watchOS 6.0, tvOS 13.0, macOS 10.15, *) {
                let cache = URLCache(memoryCapacity: 5242880, diskCapacity: 52428800)
                urlCache = cache
            } else {
                let cache = URLCache(memoryCapacity: 5242880, diskCapacity: 52428800, diskPath: diskPath)
                urlCache = cache
            }
            configuration.urlCache = urlCache
        } else {
            urlCache = nil
        }
        
        session = URLSession(configuration: configuration)
//        session.nkLogger = .init()
        emptyCacheOnAppTerminate = true
        setNotificationObservers()
    }
    
    public init(urlCache cache: URLCache? = nil, configuration config: URLSessionConfiguration) {
        urlCache = cache
        session = URLSession(configuration: config)
//        session.nkLogger = .init()
        emptyCacheOnAppTerminate = true
        setNotificationObservers()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        session.invalidateAndCancel()
    }
    
    // MARK: - NOTIFICATION OBSERVERS
    private func setNotificationObservers() {
        #if !canImport(WatchKit)
        NotificationCenter.default.addObserver(forName: notification, object: nil, queue: .init()) { [weak self] (_) in
            if let `self` = self, self.emptyCacheOnAppTerminate || NKConfiguration.emptyCacheOnAppTerminateOnAllSessions {
                self.removeAllCachedResponses()
            }
        }
        #endif
    }
}


// MARK: - URL CACHE MANAGER
extension NKConfiguration {
    
    /// Remove All Cached Responses from this session.
    open func removeAllCachedResponses() {
        session.configuration.urlCache?.removeAllCachedResponses()
    }
    
    #if DEBUG
    public func printURLCacheDetails() {
        guard let cache = session.configuration.urlCache else {
            logger.print(
                "Cannot Print Cache Memory And Disk Capacity And Usage",
                 "Error - No URL Cache Found")
            return
        }
        let byteToMb: Double = 1048576
        
        let memoryCapacity = Double(cache.memoryCapacity) / byteToMb
        let memoryUsage = Double(cache.currentMemoryUsage) / byteToMb
        
        let diskCapacity = Double(cache.diskCapacity) / byteToMb
        let diskUsage = Double(cache.currentDiskUsage) / byteToMb
        
        logger.print(
        "Current URL Cache Memory And Disk Capacity And Usage",
        "Memory Capacity: \(String(format: "%.2f", memoryCapacity)) Mb",
        "Memory Usage: \(String(format: "%.3f", memoryUsage)) Mb",
        "Disk Capacity: \(String(format: "%.2f", diskCapacity)) Mb",
        "Disk Usage: \(String(format: "%.3f", diskUsage)) Mb"
        )
    }
    #endif
}

// MARK: - SERVER ENVIRONMENT
public extension NKConfiguration {
    
    /// Updates the current environment.
    /// - Parameter newEnvironment: New Server Environment to be set.
    static func updateEnvironment(_ newEnvironment: Environment) {
        Environment.current = newEnvironment
        UserDefaults.standard.set(newEnvironment.value, forKey: "api_environment")
    }
    
    /// Returns the current environment.
    static var currentEnvironment: Environment? {
        return Environment.current
    }
}

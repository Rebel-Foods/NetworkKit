//
//  Network Configuration+Notification.swift
//  NetworkKit
//
//  Created by Raghav Ahuja on 15/10/19.
//  Copyright © 2019 Raghav Ahuja. All rights reserved.
//

#if canImport(AppKit)
import AppKit.NSApplication

// MARK: - NOTIFICATION OBSERVERS
extension NetworkConfiguration {
    var notification: Notification.Name { NSApplication.willTerminateNotification }
 
}

#elseif canImport(WatchKit)

#elseif canImport(UIKit)
import UIKit.UIApplication

// MARK: - NOTIFICATION OBSERVERS
extension NetworkConfiguration {
    var notification: Notification.Name { UIApplication.willTerminateNotification }
}

#endif

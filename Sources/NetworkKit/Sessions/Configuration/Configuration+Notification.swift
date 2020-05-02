//
//  NKConfiguration+Notification.swift
//  NetworkKit
//
//  Created by Raghav Ahuja on 15/10/19.
//

#if os(watchOS)

#elseif canImport(UIKit)
import UIKit.UIApplication

// MARK: - NOTIFICATION OBSERVERS
extension NKConfiguration {
    var notification: Notification.Name { UIApplication.willTerminateNotification }
}

#elseif canImport(AppKit)
import AppKit.NSApplication

// MARK: - NOTIFICATION OBSERVERS
extension NKConfiguration {
    var notification: Notification.Name { NSApplication.willTerminateNotification }
}

#endif

//
//  NSError.swift
//  NetworkKit
//
//  Created by Raghav Ahuja on 18/10/19.
//  Copyright © 2019 Raghav Ahuja. All rights reserved.
//

import Foundation

extension NSError {
    
    public static var networkKitErrorDomain: String { "NKErrorDomain" }
    
    static func cancelled(for url: URL?) -> NSError {
        var userInfo: [String: Any] = [NSLocalizedDescriptionKey: "User cancelled the task for url: \(url?.absoluteString ?? "nil")."]
        if let url = url {
            userInfo[NSURLErrorFailingURLErrorKey] = url
        }
        
        let error = NSError(domain: networkKitErrorDomain, code: NSURLErrorCancelled, userInfo: userInfo)
        
        return error
    }
    
    static func badServerResponse(for url: URL) -> NSError {
        let error = NSError(domain: networkKitErrorDomain, code: NSURLErrorBadServerResponse, userInfo: [
            NSURLErrorFailingURLErrorKey: url,
            NSLocalizedDescriptionKey: "Bad server response for request : \(url.absoluteString)"
        ])
        
        return error
    }
    
    static func badURL(for urlString: String?) -> NSError {
        let error = NSError(domain: networkKitErrorDomain, code: NSURLErrorBadURL, userInfo: [
            NSURLErrorFailingURLStringErrorKey: urlString ?? "nil",
            NSLocalizedDescriptionKey: "Invalid URL provied."
        ])
        
        return error
    }
    
    static func resourceUnavailable(for url: URL) -> NSError {
        let error = NSError(domain: networkKitErrorDomain, code: NSURLErrorResourceUnavailable, userInfo: [
            NSURLErrorFailingURLErrorKey: url,
            NSLocalizedDescriptionKey: "A requested resource couldn’t be retrieved from url: \(url.absoluteString)."
        ])
        
        return error
    }
    
    static func unsupportedURL(for url: URL?) -> NSError {
        var userInfo: [String: Any] = [NSLocalizedDescriptionKey: "A requested resource couldn’t be retrieved from url: \(url?.absoluteString ?? "nil")."]
        if let url = url {
            userInfo[NSURLErrorFailingURLErrorKey] = url
        }
        
        let error = NSError(domain: networkKitErrorDomain, code: NSURLErrorUnsupportedURL, userInfo: userInfo)
        
        return error
    }
    
    static func zeroByteResource(for url: URL) -> NSError {
        let error = NSError(domain: networkKitErrorDomain, code: NSURLErrorZeroByteResource, userInfo: [
            NSURLErrorFailingURLErrorKey: url,
            NSLocalizedDescriptionKey: "A server reported that a URL has a non-zero content length, but terminated the network connection gracefully without sending any data."
        ])
        
        return error
    }
    
    static func cannotDecodeContentData(for url: URL) -> NSError {
        let error = NSError(domain: networkKitErrorDomain, code: NSURLErrorCannotDecodeContentData, userInfo: [
            NSURLErrorFailingURLErrorKey: url,
            NSLocalizedDescriptionKey: "Content data received during a connection request had an unknown content encoding."
        ])
        
        return error
    }
    
    static func cannotDecodeRawData(for url: URL) -> NSError {
        let error = NSError(domain: networkKitErrorDomain, code: NSURLErrorCannotDecodeRawData, userInfo: [
            NSURLErrorFailingURLErrorKey: url,
            NSLocalizedDescriptionKey: "Content data received during a connection request had an unknown content encoding."
        ])
        
        return error
    }
    
    static func notStarted(for url: URL?) -> NSError {
        var userInfo: [String: Any] = [NSLocalizedDescriptionKey: "An asynchronous load has been canceled or not started."]
        if let url = url {
            userInfo[NSURLErrorFailingURLErrorKey] = url
        }
        
        let error = NSError(domain: networkKitErrorDomain, code: NSUserCancelledError, userInfo: userInfo)
        
        return error
    }
    
    static func unkown() -> NSError {
        let error = NSError(domain: networkKitErrorDomain, code: NSURLErrorUnknown, userInfo: [
            NSLocalizedDescriptionKey: "An Unknown Occurred."
        ])
        
        return error
    }
}

//
//  Network Error.swift
//  NetworkKit
//
//  Created by Raghav Ahuja on 15/10/19.
//  Copyright © 2019 Raghav Ahuja. All rights reserved.
//

import Foundation

public protocol NetworkError: LocalizedError {
    var errorCode: Int { get }
}

public struct NKError: NetworkError {
    public let localizedDescription: String
    public let errorDescription: String?
    
    public let errorCode: Int
    
    init(_ httpError: HTTPStatusCode) {
        errorCode = httpError.rawValue
        localizedDescription = httpError.localizedDescription
        errorDescription = localizedDescription
    }
    
    public init(_ error: NSError) {
        localizedDescription = error.localizedDescription
        errorCode = error.code
        
        if error.domain == NSCocoaErrorDomain {
            errorDescription = error.userInfo[NSDebugDescriptionErrorKey] as? String
            
        } else if error.domain == NSURLErrorDomain {
            let failingURL = error.userInfo[NSURLErrorFailingURLStringErrorKey] as? String
            let description = "Failing URL: \(failingURL ?? "nil"). \(localizedDescription)"
            errorDescription = description
            
        } else {
            errorDescription = localizedDescription
        }
    }
    
    init(_ error: NetworkError) {
        errorCode = error.errorCode
        localizedDescription = error.localizedDescription
        errorDescription = error.errorDescription
    }
    
    static func validationCancelled(for url: URL) -> NKError {
        let error = NSError(domain: NSURLErrorDomain, code: NSURLErrorCancelled, userInfo: [
            NSURLErrorFailingURLErrorKey: url,
            NSLocalizedDescriptionKey: "Response validation cancelled."
        ])
        
        return NKError(error)
    }
    
    static func badServerResponse(for url: URL) -> NKError {
        let error = NSError(domain: NSURLErrorDomain, code: NSURLErrorBadServerResponse, userInfo: [
            NSURLErrorFailingURLErrorKey: url,
            NSLocalizedDescriptionKey: "Bad server response for request : \(url.absoluteString)"
        ])
        
        return NKError(error)
    }
    
    static func resourceUnavailable(for url: URL) -> NKError {
        let error = NSError(domain: NSURLErrorDomain, code: NSURLErrorResourceUnavailable, userInfo: [
            NSURLErrorFailingURLErrorKey: url,
            NSLocalizedDescriptionKey: "A requested resource couldn’t be retrieved from url: \(url.absoluteString)."
        ])
        
        return NKError(error)
    }
    
    static func unsupportedURL(for url: URL?) -> NKError {
        let error = NSError(domain: NSURLErrorDomain, code: NSURLErrorUnsupportedURL, userInfo: [
            NSURLErrorFailingURLErrorKey: url ?? "nill",
            NSLocalizedDescriptionKey: "A requested resource couldn’t be retrieved from url: \(url?.absoluteString ?? "nil")."
        ])
        
        return NKError(error)
    }
    
    static func zeroByteResource(for url: URL) -> NKError {
        let error = NSError(domain: NSURLErrorDomain, code: NSURLErrorZeroByteResource, userInfo: [
            NSURLErrorFailingURLErrorKey: url,
            NSLocalizedDescriptionKey: "A server reported that a URL has a non-zero content length, but terminated the network connection gracefully without sending any data."
        ])
        
        return NKError(error)
    }
    
    static func cannotDecodeContentData(for url: URL) -> NKError {
        let error = NSError(domain: NSURLErrorDomain, code: NSURLErrorCannotDecodeContentData, userInfo: [
            NSURLErrorFailingURLErrorKey: url,
            NSLocalizedDescriptionKey: "Content data received during a connection request had an unknown content encoding."
        ])
        
        return NKError(error)
    }
    
    static func cannotDecodeRawData(for url: URL) -> NKError {
        let error = NSError(domain: NSURLErrorDomain, code: NSURLErrorCannotDecodeRawData, userInfo: [
            NSURLErrorFailingURLErrorKey: url,
            NSLocalizedDescriptionKey: "Content data received during a connection request had an unknown content encoding."
        ])
        
        return NKError(error)
    }
    
    static func notStarted(for url: URL?) -> NKError {
        let error = NSError(domain: NSURLErrorDomain, code: NSUserCancelledError, userInfo: [
            NSURLErrorFailingURLErrorKey: url ?? "nil",
            NSLocalizedDescriptionKey: "An asynchronous load has been canceled or not started."
        ])
        
        return NKError(error)
    }
    
    static func unkown() -> NKError {
        let error = NSError(domain: NSURLErrorDomain, code: NSURLErrorUnknown, userInfo: [
            NSLocalizedDescriptionKey: "An Unknown Occurred."
        ])
        
        return NKError(error)
    }
}

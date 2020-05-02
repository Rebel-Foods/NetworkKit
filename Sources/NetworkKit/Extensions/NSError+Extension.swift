//
//  NSError+Extension.swift
//  NetworkKit
//
//  Created by Raghav Ahuja on 18/10/19.
//

import Foundation

extension NSError {
    
    public static let networkKitErrorDomain = "NetworkKit"
    
    static func badURL(for urlString: String?) -> NSError {
        let error = NSError(domain: networkKitErrorDomain, code: NSURLErrorBadURL, userInfo: [
            NSURLErrorFailingURLStringErrorKey: urlString ?? "nil",
            NSLocalizedDescriptionKey: "Invalid URL provided."
        ])
        
        return error
    }
    
    static func zeroByteResource(for url: URL) -> NSError {
        let error = NSError(domain: networkKitErrorDomain, code: NSURLErrorZeroByteResource, userInfo: [
            NSURLErrorFailingURLErrorKey: url,
            NSURLErrorFailingURLStringErrorKey: url.absoluteString,
            NSLocalizedDescriptionKey: "A server reported that a URL has a non-zero content length, but terminated the network connection gracefully without sending any data."
        ])
        
        return error
    }
    
    static func cannotDecodeImageData(for url: URL) -> NSError {
        let error = NSError(domain: networkKitErrorDomain, code: NSURLErrorCannotDecodeRawData, userInfo: [
            NSURLErrorFailingURLErrorKey: url,
            NSURLErrorFailingURLStringErrorKey: url.absoluteString,
            NSLocalizedDescriptionKey: "Content data received during a connection request had an unknown image content encoding."
        ])
        
        return error
    }
}

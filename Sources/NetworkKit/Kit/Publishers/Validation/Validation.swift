//
//  Validation.swift
//  NetworkKit
//
//  Created by Raghav Ahuja on 18/11/19.
//  Copyright © 2019 Raghav Ahuja. All rights reserved.
//

import Foundation

public extension NKPublishers {
    
    struct Validate<Upstream: NKPublisher>: NKPublisher where Upstream.Output == NetworkKit.Output, Upstream.Failure == NetworkKit.Failure {
        
        public var queue: NetworkQueue {
            upstream.queue
        }
        
        public var result: NetworkResult<Output, Failure>
        
        public typealias Output = NetworkKit.Output
        
        public typealias Failure = NetworkKit.Failure
        
        /// The publisher from which this publisher receives elements.
        public let upstream: Upstream
        
        /// Check for any business error model on failure.
        public let shouldCheckForErrorModel: Bool
        
        /// Acceptable HTTP Status codes for the network call.
        public let acceptableStatusCodes: [Int]
        
        public init(upstream: Upstream, shouldCheckForErrorModel: Bool, acceptableStatusCodes: [Int]) {
            self.upstream = upstream
            self.shouldCheckForErrorModel = shouldCheckForErrorModel
            
            let sessionCodes = SessionManager.shared.acceptableStatusCodes
            let codes = acceptableStatusCodes.isEmpty ? sessionCodes : acceptableStatusCodes
            
            self.acceptableStatusCodes = codes
            
            result = .init()
            perform()
        }
        
        private func perform() {
            addToQueue(isSuspended: true) {
                self.doValidation()
            }
        }
        
        private func doValidation() {
            guard let url = queue.request?.url else {
                result.result = .failure(.unsupportedURL(for: nil))
                return
            }
            
            guard let (data, response) = try? upstream.result.result.get() else {
                result.result = upstream.result.result
                return
            }
            
            if acceptableStatusCodes.contains(response.statusCode) {
                
                guard !data.isEmpty else {
                    result.result = .failure(.zeroByteResource(for: url))
                    return
                }
                
                var acceptableContentTypes: [String] {
                    if let accept = queue.request?.value(forHTTPHeaderField: "Accept") {
                        return accept.components(separatedBy: ",")
                    }
                    
                    return ["*/*"]
                }
                
                guard let responseContentType = response.mimeType, let responseMIMEType = MIMEType(responseContentType) else {
                    for contentType in acceptableContentTypes {
                        if let mimeType = MIMEType(contentType), mimeType.isWildcard {
                            result.result = .success((data, response))
                            return
                        }
                    }
                    
                    result.result = .failure(.cannotDecodeContentData(for: url))
                    return
                }
                
                for contentType in acceptableContentTypes {
                    if let acceptableMIMEType = MIMEType(contentType), acceptableMIMEType.matches(responseMIMEType) {
                        result.result = .success((data, response))
                        return
                    }
                }
                
                result.result = .failure(.cannotDecodeContentData(for: url))
                
            } else {
                // On Failure it checks if it a business error.
                
                if shouldCheckForErrorModel, !data.isEmpty {
                    
                    let model = try? JSONDecoder().decode(ErrorModel.self, from: data)
                    if let errorModel = model {
                        let error = BusinessError.errorModel(errorModel, response.statusCode)
                        result.result = .failure(NKError(error))
                        
                        return
                    }
                    
                    // else throw http or url error
                    if let code = HTTPStatusCode(rawValue: response.statusCode) {
                        result.result = .failure(.init(code))
                    } else {
                        result.result = .failure(.badServerResponse(for: url))
                    }
                }
            }
        }
    }
}


private extension NKPublishers.Validate {
    
    /// ACCEPTABLE CONTENT TYPE CHECK
    struct MIMEType {
        let type: String
        let subtype: String
        
        var isWildcard: Bool { return type == "*" && subtype == "*" }
        
        init?(_ string: String) {
            let components: [String] = {
                let stripped = string.trimmingCharacters(in: .whitespacesAndNewlines)
                let split = stripped[..<(stripped.range(of: ";")?.lowerBound ?? stripped.endIndex)]
                return split.components(separatedBy: "/")
            }()
            
            if let type = components.first, let subtype = components.last {
                self.type = type
                self.subtype = subtype
            } else {
                return nil
            }
        }
        
        func matches(_ mime: MIMEType) -> Bool {
            switch (type, subtype) {
            case (mime.type, mime.subtype), (mime.type, "*"), ("*", mime.subtype), ("*", "*"):
                return true
            default:
                return false
            }
        }
    }
}

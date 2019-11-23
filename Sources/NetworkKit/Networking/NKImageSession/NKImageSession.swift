//
//  NKImageSession.swift
//  NetworkKit
//
//  Created by Raghav Ahuja on 15/10/19.
//  Copyright © 2019 Raghav Ahuja. All rights reserved.
//

import Foundation

public final class NKImageSession: NetworkConfiguration {
    
    private typealias ImageValidationResult = (response: HTTPURLResponse, data: Data, image: ImageType)
    
    public static let shared = NKImageSession()
    
    public init(useCache: Bool = true, cacheDiskPath: String? = "cachedImages") {
        let requestCachePolicy: NSURLRequest.CachePolicy = useCache ? .returnCacheDataElseLoad : .useProtocolCachePolicy
        super.init(useDefaultCache: useCache, requestCachePolicy: requestCachePolicy, cacheDiskPath: cacheDiskPath)
        emptyCacheOnAppTerminate = false
    }
}

public extension NKImageSession {
    
    /// Creates a task that retrieves the contents of a URL based on the specified URL request object, and calls a handler upon completion.
    /// - Parameter url: URL from where image has to be fetched.
    /// - Parameter useCache: Flag which allows Response and Data to be cached.
    /// - Parameter completion: The completion handler to call when the load request is complete. This handler is executed on the main queue. This completion handler takes the Result as parameter. On Success, it returns the image.  On Failure, returns URLError.
    /// - Returns: **URLSessionDataTask** for further operations.
    @discardableResult
    func fetch(from url: URL, cacheImage useCache: Bool = true, completion: @escaping (Result<ImageType, NSError>) -> ()) -> URLSessionDataTask {
        
        let requestCachePolicy: NSURLRequest.CachePolicy = useCache ? .returnCacheDataElseLoad : .reloadIgnoringLocalCacheData
        let request = URLRequest(url: url, cachePolicy: requestCachePolicy, timeoutInterval: session.configuration.timeoutIntervalForRequest)
        
        let task = session.dataTask(with: request) { [weak self] (data, response, error) in
            
            guard let `self` = self else {
                let error = NSError(domain: NSURLErrorDomain, code: NSURLErrorUnknown, userInfo: nil)
                completion(.failure(error))
                return
            }
            
            if let error = error as NSError? {
                
                #if DEBUG
                DebugPrint.print(
                    """
                    
                    ---------------------------------------------
                    Cannot Fetch Image From:
                    URL: \(url.absoluteString)
                    Error: \(error)
                    ---------------------------------------------
                    
                    """
                    , shouldPrint: self.debugPrint)
                #endif
                
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }
            
            let result = self.validateImageResponse(url: url, response: response, data: data)
            
            switch result {
            case .success(let value):
                DispatchQueue.main.async {
                    completion(.success(value.image))
                }
                
            case .failure(let networkError):
                
                #if DEBUG
                DebugPrint.print(
                    """
                    
                    ---------------------------------------------
                    Cannot Fetch Image From:
                    URL: \(url.absoluteString)
                    Error: \(networkError.localizedDescription)
                    ---------------------------------------------
                    
                    """
                    , shouldPrint: self.debugPrint)
                #endif
                
                DispatchQueue.main.async {
                    completion(.failure(networkError))
                }
            }
        }
        
        task.resume()
        return task
    }
}

private extension NKImageSession {
    
    /// Validates URL Request's HTTP Response.
    /// - Parameter response: HTTP URL Response for the provided request.
    /// - Parameter data: Response Data containing Image Data sent by server.
    /// - Returns: Result Containing Image on success or URL Error if validation fails.
    private func validateImageResponse(url: URL, response: URLResponse?, data: Data?) -> Result<ImageValidationResult, NSError> {
        
        guard let httpURLResponse = response as? HTTPURLResponse, acceptableStatusCodes.contains(httpURLResponse.statusCode),
            let mimeType = httpURLResponse.mimeType, mimeType.hasPrefix("image") else {
                return .failure(.badServerResponse(for: url))
        }
        
        guard var data = data, !data.isEmpty else {
            return .failure(.zeroByteResource(for: url))
        }
        
        guard let image = ImageType.initialize(using: &data) else {
            return .failure(.cannotDecodeRawData(for: url))
        }
        
        return .success((httpURLResponse, data, image))
    }
}

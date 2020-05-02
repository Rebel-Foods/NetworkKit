//
//  NetworkRequest.swift
//  NetworkKit
//
//  Created by Raghav Ahuja on 15/10/19.
//

import Foundation

#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

@available(*, deprecated, renamed: "NKRequest")
public typealias NetworkRequest = NKRequest

public final class NKRequest {

    var bodyData: Data? = nil
    var headers: HTTPHeaderParameters = [:]
    var networkServiceType: URLRequest.NetworkServiceType = .default
    
    var queryItems = Set<URLQueryItem>()
    
    var _request: URLRequest? = nil
    
    var fileURL: URL?
    
    public var request: URLRequest? {
        _request
    }
    
    public let apiName: String
    
    public let connection: ConnectionRepresentable
    
    /// Create a Network Request to a Connection.
    /// - Parameter endPoint: Connection for Network Request.
    public init(to endPoint: ConnectionRepresentable) {
        connection = endPoint
        apiName = endPoint.name ?? "Unknown"
    }
    
    /// Add Dynamic `URLQuery` to request.
    /// - Note: If a query already exists in request, it is replaced.
    /// - Parameter query: Query to be added in URL parameters.
    public func urlQuery(_ query: URLQuery) -> Self {
        queryItems.addURLQuery(query: query)
        return self
    }
    
    /// JSON Request Body to be attached.
    /// - Parameters:
    ///   - body: JSON Object.
    ///   - strategy: JSON Encoding strategy.
    public func requestBody<T: Encodable>(_ body: T, strategy: JSONEncoder.KeyEncodingStrategy = .useDefaultKeys) -> Self {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = strategy
        encoder.outputFormatting = .prettyPrinted
        
        do {
            let bodyData = try encoder.encode(body)
            self.bodyData = bodyData
        } catch {
            bodyData = nil
        }
        
        headers = headers.merging(HTTPBodyEncodingType.json.headers) { (_, new) in new }
        
        return self
    }
    
    /// Request Body to be attached.
    /// - Parameters:
    ///   - body: Body to be attached.
    ///   - encoding: Type of encoding with which body will be encoded.
    public func requestBody(_ body: [String: Any], encoding: HTTPBodyEncodingType) -> Self {
        bodyData = encoding.encode(body: body)
        
        headers = headers.merging(encoding.headers) { (_, new) in new }
        
        return self
    }
    
    /// Request Body to be attached.
    /// - Parameters:
    ///   - body: Body to be attached.
    ///   - httpHeaders: Additional HTTP Headers to be added for body.
    public func requestBody(_ body: Data?, httpHeaders: HTTPHeaderParameters) -> Self {
        bodyData = body
        headers = headers.merging(httpHeaders) { (_, new) in new }
        
        return self
    }
    
    /// Additional HTTP Headers to be attached to the network call.
    /// - Parameter httpHeaders: Dictionary of HTTP headers.
    public func httpHeaders(_ httpHeaders: HTTPHeaderParameters) -> Self {
        headers = headers.merging(httpHeaders) { (_, new) in new }
        
        return self
    }
    
    /// Update Network Service type for this request.
    /// - Parameter serviceType: Constants that specify how a request uses network resources.
    public func networkServiceType(_ serviceType: URLRequest.NetworkServiceType) -> Self {
        networkServiceType = serviceType
        
        return self
    }
    
    /// Returns the request created. It creates a `URLRequest` if one has not been created.
    public func getRequest() -> URLRequest? {
        if _request == nil {
            create()
        }
        return request
    }
    
    /// Add URL of file to be uploaded.
    /// - Note: This method is only called when using `uploadTask` method in `NKSession`.
    /// - Parameter fileURL: System file URL of file to be uploaded.
    public func uploadFile(fileURL: URL) -> Self {
        self.fileURL = fileURL
        bodyData = nil
        
        return self
    }
}

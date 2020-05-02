//
//  HTTP Method.swift
//  NetworkKit
//
//  Created by Raghav Ahuja on 15/10/19.
//

public enum HTTPMethod: String, Hashable {
    
    case connect    = "CONNECT"
    case delete     = "DELETE"
    case get        = "GET"
    case head       = "HEAD"
    case options    = "OPTIONS"
    case post       = "POST"
    case put        = "PUT"
    case patch      = "PATCH"
    case trace      = "TRACE"
}

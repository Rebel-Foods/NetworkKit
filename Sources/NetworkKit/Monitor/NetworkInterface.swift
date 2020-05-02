//
//  NetworkInterface.swift
//  NetworkKit
//
//  Created by Raghav Ahuja on 25/04/20.
//

/// Network interface of device.
public enum NetworkInterface: Hashable, CustomStringConvertible {
    
    /// Network is available through **Wi-Fi** connection.
    case wifi
    
    /// Network is available through **Cellular** connection.
    case cellular(CellularTechnology)
    
    /// Network is available through other connection such as wired ethernet or loopback.
    case other
    
    /// No network interface available.
    case none
    
    public var description: String {
        switch self {
        case .wifi: return "Wi-Fi"
        case .cellular(let technology): return "Cellular: \(technology.rawValue)"
        case .other: return "Ethernet or Loopback"
        case .none: return "None"
        }
    }
}

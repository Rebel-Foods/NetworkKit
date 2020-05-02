//
//  _NetworkMonitor.swift
//  NetworkKit
//
//  Created by Raghav Ahuja on 21/04/20.
//

import Network

@available(macOS 10.14, iOS 12.0, watchOS 5.0, tvOS 12.0, *)
final class _NWNetworkMonitor: NetworkMonitorType {
    
    static let `default` = _NWNetworkMonitor()
    
    private let monitor: NWPathMonitor
    
    private let queue = DispatchQueue(label: "com.networkkit.network-monitor", qos: .background)
    
    public private(set) var currentPath: NetworkPath
    
    private var _isEnabled: Bool = false
    
    var isEnabled: Bool {
        _isEnabled
    }
    
    init() {
        monitor = NWPathMonitor()
        currentPath = monitor.currentPath.networkPath
    }
    
    deinit {
        monitor.cancel()
    }
    
    func startMonitoring(handler: NetworkPathHandler?) {
        guard !_isEnabled else {
            return
        }
        
        _isEnabled = true
        updates(handler)
        monitor.start(queue: queue)
    }
    
    private func updates(_ handler: NetworkPathHandler?) {
        guard let handler = handler else {
            return
        }
        
        monitor.pathUpdateHandler = { [weak self] (path) in
            
            guard let `self` = self else {
                return
            }
            
            let networkPath = path.networkPath
            self.currentPath = networkPath
            
            handler(networkPath)
        }
    }
    
    func stopMonitoring() {
        guard _isEnabled else {
            return
        }
        
        _isEnabled = false
        monitor.cancel()
        monitor.pathUpdateHandler = nil
    }
}

@available(macOS 10.14, iOS 12.0, watchOS 5.0, tvOS 12.0, *)
extension NWInterface.InterfaceType {
    
    func _networkInterface(cellular: CellularTechnology) -> NetworkInterface {
        switch self {
        case .wifi                              : return .wifi
        case .cellular                          : return .cellular(cellular)
        case .other, .wiredEthernet, .loopback  : return .other
        @unknown default                        : return .other
        }
    }
}

@available(macOS 10.14, iOS 12.0, watchOS 5.0, tvOS 12.0, *)
extension NWPath.Status {
    
    var _status: NetworkPath.Status {
        switch self {
        case .satisfied             : return .satisfied
        case .unsatisfied           : return .unsatisfied
        case .requiresConnection    : return .requiresConnection
        @unknown default            : return .satisfied
        }
    }
}

@available(macOS 10.14, iOS 12.0, watchOS 5.0, tvOS 12.0, *)
extension NWPath {
    
    var networkPath: NetworkPath {
        
        let isExpensive = self.isExpensive
        let status = self.status._status
        let interface = availableInterfaces.first?.type._networkInterface(cellular: _NWNetworkMonitor.cellularConnectionType) ?? .none
        
        if #available(OSX 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *) {
            return NetworkPath(isConstrained: isConstrained, isExpensive: isExpensive, interface: interface, status: status)
        } else {
            return NetworkPath(isExpensive: isExpensive, interface: interface, status: status)
        }
    }
}

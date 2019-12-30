//
//  NKLogger.swift
//  NetworkKit
//
//  Created by Raghav Ahuja on 18/10/19.
//  Copyright © 2019 Raghav Ahuja. All rights reserved.
//

import Foundation

final public class NKLogger {
    
    /// Allows Logs to be Printed in Debug Console.
    /// Default value is `true`
    public var isLoggingEnabled: Bool = true
    
    public static let `default` = NKLogger()
    
    /**
     Creates a `NKLogger`.
     */
    public init() { }
    
    /**
     Writes the textual representations of the given items into the standard output.
     
     - parameter items: Zero or more items to print..
     - parameter separator: A string to print between each item. The default is a single space (" ").
     - parameter terminator: The string to print after all items have been printed. The default is a newline ("\n").
     
     */
    func print(_ items: Any..., separator: String = " ", terminator: String = "\n") {
        #if DEBUG
        guard NKConfiguration.allowLoggingOnAllSessions, isLoggingEnabled else { return }
        Swift.print(items, separator: separator, terminator: terminator)
        #endif
    }
    
    /**
     Writes the textual representations of the given items most suitable for debugging into the standard output.
     
     - parameter items: Zero or more items to print.
     - parameter separator: A string to print between each item. The default is a single space (" ").
     - parameter terminator: The string to print after all items have been printed. The default is a newline ("\n").
     
     */
    func debugPrint(_ items: Any..., separator: String = " ", terminator: String = "\n") {
        #if DEBUG
        guard NKConfiguration.allowLoggingOnAllSessions, isLoggingEnabled else { return }
        Swift.debugPrint(items, separator: separator, terminator: terminator)
        #endif
    }
    
    /**
     Handles APIRequest logging sent by the `NetworkKit`.
     
     - parameter request: URLRequest
     - parameter apiName: API name.
     */
    func logAPIRequest(request: URLRequest?, apiName: String?) {
        #if DEBUG
        guard NKConfiguration.allowLoggingOnAllSessions, isLoggingEnabled else { return }
        
        Swift.print(
            """
            ------------------------------------------------------------
            API Call Request for:
            Name: \(apiName ?? "nil")
            \(request?.debugDescription ?? "")
            
            """
        )
        #endif
    }
    
    /**
     Print JSON sent by the `NetworkKit`.
     
     - parameter data: Input Type to be printed
     - parameter apiName: API name.
     */
    func printJSON<Input>(data: Input, apiName: String) {
        #if DEBUG
        guard NKConfiguration.allowLoggingOnAllSessions, isLoggingEnabled else { return }
        guard let data = data as? Data else {
            return
        }
        
        do {
            let object = try JSONSerialization.jsonObject(with: data, options: [])
            let newData = try JSONSerialization.data(withJSONObject: object, options: .prettyPrinted)
            
//            Swift.print(
//                """
//                ------------------------------------------------------------
//                Printing JSON for:
//                API Name: \(apiName)
//                JSON:
//
            //                """)
            Swift.print("""
                    ------------------------------------------------------------
                    JSON:
                           
                    """)
            Swift.print(String(data: newData, encoding: .utf8) ?? "nil")
            Swift.print("------------------------------------------------------------")
            
        } catch {
            
        }
        #endif
    }
    
    /**
     Handles errors sent by the `NetworkKit`.
     
     - parameter error: Error occurred.
     - parameter file: Source file name.
     - parameter line: Source line number.
     - parameter function: Source function name.
     */
    @inline(__always)
    func log(error: Error, file: StaticString = #file, line: UInt = #line, function: StaticString = #function) {
        #if DEBUG
        guard NKConfiguration.allowLoggingOnAllSessions, isLoggingEnabled else { return }
        
        Swift.print("⚠️ [NetworkKit: Error] \((String(describing: file) as NSString).lastPathComponent):\(line) \(function)\n  ↪︎ \(error as NSError)\n")
        #endif
    }
    
    /**
     Handles assertions made throughout the `NetworkKit`.
     
     - parameter condition: Assertion condition.
     - parameter message: Assertion failure message.
     - parameter file: Source file name.
     - parameter line: Source line number.
     - parameter function: Source function name.
     */
    @inline(__always)
    func assert(_ condition: @autoclosure () -> Bool, _ message: @autoclosure () -> String, file: StaticString = #file, line: UInt = #line, function: StaticString = #function) {
        
        #if DEBUG
        let condition = condition()
        
        if condition { return }
        
        let message = message()
        
        Swift.print("❗ [NetworkKit: Assertion Failure] \((String(describing: file) as NSString).lastPathComponent):\(line) \(function)\n  ↪︎ \(message)\n")
        Swift.assert(condition, message, file: file, line: line)
        #endif
    }
    
    /**
     Handles assertion failures made throughout the `NetworkKit`.
     
     - parameter message: Assertion failure message.
     - parameter file: Source file name.
     - parameter line: Source line number.
     - parameter function: Source function name.
     */
    @inlinable public func assertionFailure(_ message: @autoclosure () -> String = String(), file: StaticString = #file, line: UInt = #line, function: StaticString = #function) {
        let message = message()
        Swift.print("❗ [NetworkKit: Assertion Failure] \((String(describing: file) as NSString).lastPathComponent):\(line) \(function)\n  ↪︎ \(message)\n")
        Swift.assertionFailure(message, file: file, line: line)
    }
    
    /**
     Handles precondition failures made throughout the `NetworkKit`.
     
     - parameter message: Assertion failure message.
     - parameter file: Source file name.
     - parameter line: Source line number.
     - parameter function: Source function name.
     */
    @inlinable public func preconditionFailure(_ message: @autoclosure () -> String = String(), file: StaticString = #file, line: UInt = #line, function: StaticString = #function) -> Never {
        let message = message()
        Swift.print("❗ [NetworkKit: Assertion Failure] \((String(describing: file) as NSString).lastPathComponent):\(line) \(function)\n  ↪︎ \(message)\n")
        Swift.preconditionFailure(message, file: file, line: line)
    }
    
    /**
     Handles preconditions made throughout the `NetworkKit`.
     
     - parameter condition: Precondition to be satisfied.
     - parameter message: Precondition failure message.
     - parameter file: Source file name.
     - parameter line: Source line number.
     - parameter function: Source function name.
     */
    @inline(__always)
    func precondition(_ condition: @autoclosure () -> Bool, _ message: @autoclosure () -> String, file: StaticString = #file, line: UInt = #line, function: StaticString = #function) {
        
        #if DEBUG
        let condition = condition()
        
        if condition { return }
        
        let message = message()
        
        Swift.print("❗ [NetworkKit: Precondition Failure] \((String(describing: file) as NSString).lastPathComponent):\(line) \(function)\n  ↪︎ \(message)\n")
        Swift.preconditionFailure(message, file: file, line: line)
        #endif
    }
    
    /**
     Handles fatal errors made throughout the `NetworkKit`.
     - Important: Implementers should guarantee that this function doesn't return, either by calling another `Never` function such as `fatalError()` or `abort()`, or by raising an exception.
     
     - parameter message: Fatal error message.
     - parameter file: Source file name.
     - parameter line: Source line number.
     - parameter function: Source function name.
     */
    @inline(__always)
    func fatalError(_ message: @autoclosure () -> String, file: StaticString = #file, line: UInt = #line, function: StaticString = #function) -> Never {
        
        #if DEBUG
        let message = message()
        Swift.print("❗ [NetworkKit: Fatal Error] \((String(describing: file) as NSString).lastPathComponent):\(line) \(function)\n  ↪︎ \(message)\n")
        Swift.fatalError(message, file: file, line: line)
        #endif
    }
}

//
//  ImageSession+AppKit.swift
//  NetworkKit
//
//  Created by Raghav Ahuja on 15/10/19.
//

#if canImport(UIKit)
import UIKit.UIImage

public extension NKImageSession {
    typealias ImageType = UIImage
}

#elseif canImport(AppKit)
import AppKit.NSImage

public extension NKImageSession {
    typealias ImageType = NSImage
}

#endif

//
//  UIImage+NSImage+Extension.swift
//  NetworkKit
//
//  Created by Raghav Ahuja on 15/10/19.
//  Copyright © 2019 Raghav Ahuja. All rights reserved.
//

#if canImport(WatchKit)

import UIKit.UIImage

extension UIImage {
    
    static func initialize(using data: inout Data) -> UIImage? {
        UIImage(data: data)
    }
}

#elseif canImport(UIKit)

import UIKit.UIImage

extension UIImage {
    
    static func initialize(using data: inout Data) -> UIImage? {
        UIImage(data: data, scale: UIScreen.main.scale)
    }
}

#elseif canImport(AppKit)

import AppKit.NSImage

extension NSImage {
    
    static func initialize(using data: inout Data) -> NSImage? {
        NSImage(data: data)
    }
}

#endif

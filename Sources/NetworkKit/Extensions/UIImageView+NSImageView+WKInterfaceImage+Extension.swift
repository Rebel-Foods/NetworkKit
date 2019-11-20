//
//  UIImageView+NSImageView+WKInterfaceImage+Extension.swift
//  NetworkKit
//
//  Created by Raghav Ahuja on 15/10/19.
//  Copyright © 2019 Raghav Ahuja. All rights reserved.
//

#if canImport(WatchKit)

import WatchKit

extension WKInterfaceImage: ImageDownloadDelegate {
    
    public var image: ImageType? {
        get { nil }
        set { setImage(newValue) }
    }
    
    open func prepareForReuse(_ placeholder: ImageType? = nil) {
        setImage(placeholder)
    }
}

#elseif canImport(UIKit)

import UIKit.UIImage

extension UIImageView: ImageDownloadDelegate {
    
    open func prepareForReuse(_ placeholder: ImageType? = nil) {
        image = placeholder
    }
}

#elseif canImport(AppKit)

import AppKit.NSImage

extension NSImageView: ImageDownloadDelegate {
    
    open func prepareForReuse(_ placeholder: ImageType? = nil) {
        image = placeholder
    }
}

#endif

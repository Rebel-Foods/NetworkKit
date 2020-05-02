//
//  UIImageView+NSImageView+WKInterfaceImage+Extension.swift
//  NetworkKit
//
//  Created by Raghav Ahuja on 15/10/19.
//

#if canImport(WatchKit)

import WatchKit

extension WKInterfaceImage: NKImageSessionDelegate {
    
    public var image: ImageType? {
        get { nil }
        set { setImage(newValue) }
    }
    
    @objc open func prepareForReuse(_ placeholder: ImageType? = nil) {
        setImage(placeholder)
    }
}

#elseif canImport(UIKit)

import UIKit.UIImage

extension UIImageView: NKImageSessionDelegate {
    
    @objc open func prepareForReuse(_ placeholder: ImageType? = nil) {
        image = placeholder
    }
}

#elseif canImport(AppKit)

import AppKit.NSImage

extension NSImageView: NKImageSessionDelegate {
    
    @objc open func prepareForReuse(_ placeholder: ImageType? = nil) {
        image = placeholder
    }
}

#endif

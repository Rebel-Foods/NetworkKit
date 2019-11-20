//
//  ImageSession+AppKit.swift
//  NetworkKit
//
//  Created by Raghav Ahuja on 15/10/19.
//  Copyright © 2019 Raghav Ahuja. All rights reserved.
//

#if canImport(AppKit)
import AppKit.NSImage

public extension ImageSessionManager {
    typealias ImageType = NSImage
}

#elseif canImport(WatchKit)
import UIKit.UIImage

public extension ImageSessionManager {
    typealias ImageType = UIImage
}

#elseif canImport(UIKit)
import UIKit.UIImage

public extension ImageSessionManager {
    typealias ImageType = UIImage
}

#endif

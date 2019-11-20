//
//  ImageDownloadDelegate.swift
//  NetworkKit
//
//  Created by Raghav Ahuja on 15/10/19.
//  Copyright © 2019 Raghav Ahuja. All rights reserved.
//
import Foundation

public protocol ImageDownloadDelegate: class {
    
    typealias ImageType = ImageSessionManager.ImageType
    
    var image: ImageType? { get set }
    
    @discardableResult
    func fetch(from url: URL, setImageAutomatically flag: Bool, placeholder: ImageType?, completion: ((ImageType?) -> ())?) -> URLSessionDataTask
    
    @discardableResult
    func fetch(fromUrlString urlString: String?, setImageAutomatically flag: Bool, placeholder: ImageType?, completion: ((ImageType?) -> ())?) -> URLSessionDataTask?
    
    func prepareForReuse(_ placeholder: ImageType?)
}

public extension ImageDownloadDelegate {
    
    
    /// Fetches Image from provided URL String and sets it on this UIImageView.
    /// - Parameter urlString: URL String from where image has to be fetched.
    /// - Parameter flag: Bool to set image automatically after downloading. Default value is `true`.
    /// - Parameter placeholder: Place holder image to be displayed until image is downloaded. Default value is `nil`.
    /// - Parameter completion: Completion Block which provides image if downloaded successfully.
    /// - Returns: URLSessionDataTask if URL is correctly formed else returns `nil`.
    @discardableResult
    func fetch(from url: URL, setImageAutomatically flag: Bool, placeholder: ImageType?, completion: ((ImageType?) -> ())?) -> URLSessionDataTask {
        _fetch(from: url, setImageAutomatically: flag, placeholder: placeholder, completion: completion)
    }
    
    
    /// Fetches Image from provided URL and sets it on this UIImageView.
    /// - Parameter url: URL from where image has to be fetched.
    /// - Parameter flag: Bool to set image automatically after downloading. Default value is `true`.
    /// - Parameter placeholder: Place holder image to be displayed until image is downloaded. Default value is `nil`.
    /// - Parameter completion: Completion Block which provides image if downloaded successfully.
    /// - Returns: URLSessionDataTask.
    @discardableResult
    func fetch(fromUrlString urlString: String?, setImageAutomatically flag: Bool, placeholder: ImageType?, completion: ((ImageType?) -> ())?) -> URLSessionDataTask? {
        _fetch(fromUrlString: urlString, setImageAutomatically: flag, placeholder: placeholder, completion: completion)
    }
}


private extension ImageDownloadDelegate {
    
    @inline(__always)
    func _fetch(fromUrlString urlString: String?,
                         setImageAutomatically flag: Bool = true, placeholder: ImageType? = nil,
                         completion: ((ImageType?) -> ())? = nil) -> URLSessionDataTask? {
        
        if let placeholder = placeholder {
            image = placeholder
        }
        
        guard let urlStringValue = urlString, let url = URL(string: urlStringValue) else {
            #if DEBUG
            print("""
                
                ---------------------------------------------
                Cannot Fetch Image From:
                URL: \(String(describing: urlString))
                Error: \(URLError(.badURL).localizedDescription)
                ---------------------------------------------
                
                """)
            #endif
            
            if flag {
                image = nil
            }
            
            completion?(nil)
            return nil
        }
        
        return _fetch(from: url, setImageAutomatically: flag, completion: completion)
    }
    
    @inline(__always)
    func _fetch(from url: URL,
                         setImageAutomatically flag: Bool = true, placeholder: ImageType? = nil,
                         completion: ((ImageType?) -> ())? = nil) -> URLSessionDataTask {
        
        if let placeholder = placeholder {
            image = placeholder
        }
        
        return ImageSessionManager.shared.fetch(from: url) { [weak self] (result) in
            switch result {
            case .success(let newImage):
                if flag {
                    self?.image = newImage
                }
                completion?(newImage)
                
            case .failure:
                if flag {
                    self?.image = nil
                }
                completion?(nil)
            }
        }
    }
}

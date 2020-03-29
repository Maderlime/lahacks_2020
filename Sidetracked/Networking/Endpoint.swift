//
//  Endpoint.swift
//  Sidetracked
//
//  Created by Andrew Graves on 3/28/20.
//  Copyright © 2020 Andrew Graves. All rights reserved.
//

import Foundation

protocol Endpoint {
    var base: String { get }
    var path: String { get }
//    var queryItems: [URLQueryItem] { get }
}

extension Endpoint {
    // Returns an instance of URLComponents containing the base URL, path and query items provided
    var urlComponents: URLComponents {
        var components = URLComponents(string: base)!
        components.path = path
//        components.queryItems = queryItems
        
        return components
    }
    
    // Returns an instance of URLRequest encapsulating the endpoint URL. This URL is obtained through the `urlComponents` object.
    var request: URLRequest {
        let url = urlComponents.url!
        return URLRequest(url: url)
    }
}

enum SidetrackedEndpoints {
    
    // creates endpoints useful for calling the API
    case getPotholesNear(lattitude: Double, longitude: Double)
    case getPotholeDetails(id: Int)
    case reportPotholeAt(lattitude: Double, longitude: Double)
}

extension SidetrackedEndpoints: Endpoint {
    var base: String {
        return "http://150.136.108.105"
    }
    
    var path: String {
        switch self {
        case .getPotholesNear: return "/all-potholes"
        case .getPotholeDetails: return "/"
        case .reportPotholeAt: return "/add-pothole"
        }
    }
    
//    var queryItems: [URLQueryItem] {
//        switch self {
//        case .getPotholesNear(let lattitude, let longitude):
//            return []
//        case .getPotholeDetails(let id):
//            return []
//        case .reportPotholeAt(let lattitude, let longitude):
//            return []
//        }
//    }
}

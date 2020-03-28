//
//  NetworkRequestable.swift
//  Sidetracked
//
//  Created by Andrew Graves on 3/28/20.
//  Copyright © 2020 Andrew Graves. All rights reserved.
//

import Foundation

protocol NetworkRequestable: Codable {
    static var path: String { get }
    
    static func endpoint(page: Int) -> URL?
}

extension NetworkRequestable {
    static var baseURL: URL? {
        return URL(string: "http://swapi.co/api/")
    }

    static func endpoint(page: Int) -> URL? {
        guard let url = baseURL else { return nil }
        var components = URLComponents(url: url.appendingPathComponent(path), resolvingAgainstBaseURL: false)
        components?.queryItems = [URLQueryItem(name: "page", value: "\(page)")]
        return components?.url
    }
}

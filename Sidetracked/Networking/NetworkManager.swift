//
//  NetworkingManager.swift
//  Sidetracked
//
//  Created by Andrew Graves on 3/28/20.
//  Copyright © 2020 Andrew Graves. All rights reserved.
//

import UIKit

struct NetworkManager {
    private static let session = URLSession(configuration: .default)
    
    static func fetch(endpoint: URL, completion: @escaping (Result<Data>) -> Void) {
        fetch(url: endpoint, completion: completion)
    }
    
    static func fetch(url: URL, completion: @escaping (Result<Data>) -> Void) {
        let request = URLRequest(url: url)
        
        let task = session.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
            } else if let data = data {
                completion(.success(data))
            }
        }
        
        task.resume()
    }
}

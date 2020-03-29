//
//  Networker.swift
//  Sidetracked
//
//  Created by Andrew Graves on 3/28/20.
//  Copyright © 2020 Andrew Graves. All rights reserved.
//

import Foundation

class Networker {
    static func request(url: URLRequest, completion: @escaping (Result<Data, Error>) -> Void) {
        
        URLSession.shared.dataTask(with: url) {
            data, response, error in
            if let data = data {
                completion(.success(data))
            } else if let error = error {
                completion(.failure(error))
            }
        }.resume()
    }
}

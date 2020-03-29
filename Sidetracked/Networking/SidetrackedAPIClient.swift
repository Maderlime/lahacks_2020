//
//  SidetrackedAPIClient.swift
//  Sidetracked
//
//  Created by Andrew Graves on 3/28/20.
//  Copyright © 2020 Andrew Graves. All rights reserved.
//

import Foundation

class SidetrackedAPIClient: APIClient {
    var session: URLSession
    
    init(configuration: URLSessionConfiguration) {
        self.session = URLSession(configuration: configuration)
    }
    
    convenience init() {
        self.init(configuration: .default)
    }
    
    // The different calls to the API would go here...
    func getPotholesNear(lattitude: Double, longitude: Double, completion: @escaping (Result<[Pothole], APIError>) -> Void) {
        let endpoint = SidetrackedEndpoints.getPotholesNear(lattitude: lattitude, longitude: longitude)
        let decoder = JSONDecoder.dataDecoder
        
        let request = endpoint.request
        
        // TO BE IMPLEMENTED
        fetch(with: request, completion: completion) { data -> [Pothole] in
            let potholeData = try decoder.decode([Pothole].self, from: data)
            print(potholeData)
            return potholeData
        }
    }
    
    func getPotholeDetails(withId id: Int, completion: @escaping (Result<Pothole, APIError>) -> Void) {
        let endpoint = SidetrackedEndpoints.getPotholeDetails(id: id)
        let decoder = JSONDecoder.dataDecoder
        
        let request = endpoint.request
        
        fetch(with: request, completion: completion) { data -> Pothole in
            let potholeData = try decoder.decode(Pothole.self, from: data)
            
            print(potholeData.id)
            return potholeData
        }
    }
    
    func reportPotholeAt(lattitude: Double, longitude: Double, completion: @escaping (Result<Bool, APIError>) -> Void) {
        let endpoint = SidetrackedEndpoints.reportPotholeAt(lattitude: lattitude, longitude: longitude)
        let decoder = JSONDecoder.dataDecoder
        
        let request = endpoint.request
    }
    
}

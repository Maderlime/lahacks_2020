//
//  APIClient.swift
//  Sidetracked
//
//  Created by Andrew Graves on 3/28/20.
//  Copyright © 2020 Andrew Graves. All rights reserved.
//

import Foundation

enum APIError: Error {
    case requestFailed
    case jsonConversionFailure
    case invalidData
    case responseUnsuccessful
    case jsonParsingFailure
    case networkerError(description: String)
    
    var localizedDescription: String {
        switch self {
        case .requestFailed: return "Request Failed"
        case .invalidData: return "Invalid Data"
        case .responseUnsuccessful: return "Response Unsuccessful"
        case .jsonParsingFailure: return "JSON Parsing Failure"
        case .jsonConversionFailure: return "JSON Conversion Failure"
        case .networkerError(let description): return "Networker Error. Description: \(description)"
        }
    }
}

protocol APIClient {
    func fetch<T: Decodable>(with request: URLRequest, completion: @escaping (Result<T, APIError>) -> Void, parse: @escaping (Data) throws -> T?)
}

extension APIClient {
    func fetch<T: Decodable>(with request: URLRequest, completion: @escaping (Result<T, APIError>) -> Void, parse: @escaping (Data) throws -> T? ) {
        
        Networker.request(url: request) { result in
            do {
                let data = try result.get()
                
                if let value = try parse(data) {
                    completion(.success(value))
                }
                
            } catch DecodingError.dataCorrupted(let context) {
                print("Data Corrupted: context: \(context)")
                completion(Result.failure(APIError.jsonConversionFailure))
                    
            } catch DecodingError.keyNotFound(let key, let context) {
                print("\n\(key) was not found with \(context) \n")
                completion(Result.failure(APIError.jsonParsingFailure))
                
            } catch DecodingError.typeMismatch(let type, let context) {
                print("Type Mismatch: type \(type), context \(context)")
                completion(Result.failure(APIError.jsonConversionFailure))
                
            } catch DecodingError.valueNotFound(let type, let context) {
                print("Value Not Found: type \(type), context \(context)")
                completion(Result.failure(APIError.jsonConversionFailure))

            } catch {
                completion(Result.failure(.networkerError(description: "\(error)")))
            }
        }
    }
}

//
//  Result.swift
//  Sidetracked
//
//  Created by Andrew Graves on 3/28/20.
//  Copyright © 2020 Andrew Graves. All rights reserved.
//

import Foundation

enum Result<Value> {
    case success(Value)
    case failure(Error)
    
    init(_ executor: () throws -> Value) {
        do {
            self = try .success(executor())
        } catch {
            self = .failure(error)
        }
    }
    
    func map<T>(_ transform: (Value) -> T) -> Result<T> {
        switch self {
        case .success(let val): return .success(transform(val))
        case .failure(let err): return .failure(err)
        }
    }
    
    func flatMap<T>(_ transform: (Value) throws -> T) -> Result<T> {
        switch self {
        case .success(let val):
            do {
                return try .success(transform(val))
            } catch {
                return .failure(error)
            }
        case .failure(let err): return .failure(err)
        }
    }
    
    func unpack() throws -> Value {
        switch self {
        case .success(let val): return val
        case .failure(let err): throw err
        }
    }
}

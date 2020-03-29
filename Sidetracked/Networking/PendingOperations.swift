//
//  PendingOperations.swift
//  Sidetracked
//
//  Created by Andrew Graves on 3/28/20.
//  Copyright © 2020 Andrew Graves. All rights reserved.
//

import Foundation

class PendingOperations {
    lazy var downloadsInProgress: [IndexPath: Operation] = [:]
    lazy var downloadQueue: OperationQueue = {
        var queue = OperationQueue()
        queue.name = "Download Queue"
        return queue
    } ()
    
    lazy var accelerationDataFetchInProgress: [IndexPath: Operation] = [:]
    lazy var filtrationQueue: OperationQueue = {
        var queue = OperationQueue()
        queue.name = "Acceleration Data Queue"
        return queue
    } ()
}

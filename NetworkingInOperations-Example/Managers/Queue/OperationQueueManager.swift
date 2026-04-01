//
//  OperationQueueManager.swift
//  NetworkingInOperations-Example
//
//  Created by William Boles on 29/07/2018.
//  Copyright © 2018 Boles. All rights reserved.
//

import Foundation

class OperationQueueManager {
    
    lazy var queue: OperationQueue = {
        let queue = OperationQueue()
        
        return queue;
    }()

    // MARK: - Singleton
    
    static let shared = OperationQueueManager()
    
    // MARK: - Addition
    
    func enqueue(_ operation: Operation) {
        queue.addOperation(operation)
    }
}

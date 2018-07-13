//
//  QueueManager.swift
//  BikePoint
//
//  Created by William Boles on 23/06/2017.
//  Copyright © 2017 Springtiger. All rights reserved.
//

import Foundation

class QueueManager {
    
    lazy var queue: OperationQueue = {
        let queue = OperationQueue()
        
        return queue;
    }()

    // MARK: - Singleton
    
    static let shared = QueueManager()
    
    // MARK: - Addition
    
    func enqueue(_ operation: Operation) {
        queue.addOperation(operation)
    }
}

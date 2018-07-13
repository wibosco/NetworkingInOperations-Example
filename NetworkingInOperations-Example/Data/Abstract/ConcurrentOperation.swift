//
//  ConcurrentOperation.swift
//  NetworkingInOperations-Example
//
//  Created by William Boles on 11/07/2018.
//  Copyright © 2018 Boles. All rights reserved.
//

import Foundation
import UIKit

enum DataRequestResult<T> {
    case success(T)
    case failure(Error)
}

class ConcurrentOperation<T>: Operation {
    
    typealias OperationCompletionHandler = (_ result: DataRequestResult<T>) -> Void
    
    var completionHandler: (OperationCompletionHandler)?
    
    // MARK: - Types
    
    enum State: String {
        case ready = "isReady",
        executing = "isExecuting",
        finished = "isFinished"
    }
    
    // MARK: - Properties
    
    var state = State.ready {
        willSet {
            willChangeValue(forKey: newValue.rawValue)
            willChangeValue(forKey: state.rawValue)
        }
        didSet {
            didChangeValue(forKey: oldValue.rawValue)
            didChangeValue(forKey: state.rawValue)
        }
    }
    
    // MARK: - Operation
    
    override var isReady: Bool {
        return super.isReady && state == .ready
    }
    
    override var isExecuting: Bool {
        return state == .executing
    }
    
    override var isFinished: Bool {
        return state == .finished
    }
    
    override var isAsynchronous: Bool {
        return true
    }
    
    // MARK: - Control
    
    override func start() {
        super.start()
        
        if !isExecuting {
            state = .executing
        }
    }
    
    func finish() {
        if isExecuting {
            state = .finished
        }
    }
    
    func complete(result: DataRequestResult<T>) {
        finish()
        
        completionHandler?(result)
    }
    
    override func cancel() {
        super.cancel()
        
        finish()
    }
}

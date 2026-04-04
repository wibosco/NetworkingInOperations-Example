//
//  ConcurrentOperation.swift
//  NetworkingInOperations-Example
//
//  Created by William Boles on 11/07/2018.
//  Copyright © 2018 Boles. All rights reserved.
//

import Foundation

enum ConcurrentOperationError: Error, Equatable {
    case cancelled
}

class ConcurrentOperation<Value>: Operation, @unchecked Sendable  {
    private(set) var completionHandler: ((_ result: Result<Value, Error>) -> Void)?
    
    private let lock = NSRecursiveLock()
    
    // MARK: - Init
    
    init(completionHandler: @escaping (_ result: Result<Value, Error>) -> Void) {
        self.completionHandler = completionHandler
        
        super.init()
    }
    
    // MARK: - State
    
    private enum State: String {
        case ready = "isReady"
        case executing = "isExecuting"
        case finished = "isFinished"
    }
    
    private var _state = State.ready {
        willSet {
            willChangeValue(forKey: _state.rawValue)
            willChangeValue(forKey: newValue.rawValue)
        }
        didSet {
            didChangeValue(forKey: oldValue.rawValue)
            didChangeValue(forKey: _state.rawValue)
        }
    }
    
    private var state: State {
        get {
            lock.lock()
            defer { lock.unlock() }
            
            return _state
        }
        set {
            lock.lock()
            defer { lock.unlock() }
            
            _state = newValue
        }
    }
    
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
    
    // MARK: - Lifecycle
    
    override func start() {
        guard !isCancelled else {
            finish(result: .failure(ConcurrentOperationError.cancelled))
            return
        }
        
        state = .executing
        
        main()
    }
    
    func finish(result: Result<Value, Error>) {
        lock.lock()
        defer { lock.unlock() }
        
        guard !isFinished else {
            return
        }
        
        state = .finished
        
        completionHandler?(result)
    }
    
    override func cancel() {
        super.cancel()
        
        finish(result: .failure(ConcurrentOperationError.cancelled))
    }
}

//
//  StubOperationQueue.swift
//  NetworkingInOperations-ExampleTests
//
//  Created by William Boles on 02/04/2026.
//  Copyright © 2026 Boles. All rights reserved.
//

import Foundation

@testable import NetworkingInOperations_Example

class StubOperationQueue: OperationQueueType {
    enum Event: Equatable {
        case addOperation(Operation)
    }
    
    private(set) var events: [Event] = []
    
    func addOperation(_ op: Operation) {
        events.append(.addOperation(op))
    }
}

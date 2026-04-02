//
//  StubURLSessionDataTask.swift
//  NetworkingInOperations-ExampleTests
//
//  Created by William Boles on 02/04/2026.
//  Copyright © 2026 Boles. All rights reserved.
//

import Foundation

@testable import NetworkingInOperations_Example

class StubURLSessionDataTask: URLSessionDataTaskType {
    enum Event: Equatable {
        case resume
        case cancel
    }
    
    private(set) var events: [Event] = []
        
    func resume() {
        events.append(.resume)
    }
    
    func cancel() {
        events.append(.cancel)
    }
}

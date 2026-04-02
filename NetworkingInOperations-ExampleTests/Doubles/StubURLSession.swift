//
//  StubURLSession.swift
//  NetworkingInOperations-ExampleTests
//
//  Created by William Boles on 02/04/2026.
//  Copyright © 2026 Boles. All rights reserved.
//

import Foundation

@testable import NetworkingInOperations_Example

class StubURLSession: URLSessionType {
    enum Event {
        case dataTask(URLRequest, (Data?, URLResponse?, (any Error)?) -> Void)
    }
    
    var dataTask: URLSessionDataTaskType!
    
    private(set) var events: [Event] = []
    
    func dataTask(with request: URLRequest,
                  completionHandler: @escaping (Data?, URLResponse?, (any Error)?) -> Void) -> any URLSessionDataTaskType {
        events.append(.dataTask(request, completionHandler))
        
        return dataTask
    }
}

//
//  StubJSONDecoder.swift
//  NetworkingInOperations-ExampleTests
//
//  Created by William Boles on 02/04/2026.
//  Copyright © 2026 Boles. All rights reserved.
//

import Foundation

@testable import NetworkingInOperations_Example

class StubJSONDecoder: JSONDecoderType {
    enum Event {
        case decode(Any, Data)
    }
    
    var decodeResult: Result<Any, Error>!
    
    private(set) var events: [Event] = []
    
    func decode<T>(_ type: T.Type,
                   from data: Data) throws -> T where T : Decodable {
        events.append(.decode(type, data))
        
        return try decodeResult.get() as! T
    }
}

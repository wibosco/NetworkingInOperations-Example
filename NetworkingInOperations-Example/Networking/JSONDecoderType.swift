//
//  JSONDecoderProtocol.swift
//  NetworkingInOperations-Example
//
//  Created by William Boles on 02/04/2026.
//  Copyright © 2026 Boles. All rights reserved.
//

import Foundation

protocol JSONDecoderType {
    func decode<T>(_ type: T.Type,
                   from data: Data) throws -> T where T : Decodable
}

extension JSONDecoder: JSONDecoderType { }

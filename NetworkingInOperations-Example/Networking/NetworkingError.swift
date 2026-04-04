//
//  NetworkingError.swift
//  NetworkingInOperations-Example
//
//  Created by William Boles on 01/04/2026.
//  Copyright © 2026 Boles. All rights reserved.
//

import Foundation

enum NetworkingError: Error, Equatable {
    case missingData
    case serialization
    case invalidStatusCode(Int)
}

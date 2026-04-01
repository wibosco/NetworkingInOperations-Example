//
//  NetworkingError.swift
//  NetworkingInOperations-Example
//
//  Created by William Boles on 01/04/2026.
//  Copyright © 2026 Boles. All rights reserved.
//

import Foundation

enum APIError: Error {
    case unknown
    case invalidRequest
    case missingData
    case serialization
    case invalidData
}

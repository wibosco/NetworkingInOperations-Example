//
//  RequestConfig.swift
//  NetworkingInOperations-Example
//
//  Created by William Boles on 12/07/2018.
//  Copyright © 2018 William Boles. All rights reserved.
//

import Foundation

enum HTTPRequestMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

class RequestConfig {
    
    let APIHost: String
    
    // MARK: - Init
    
    init() {
        self.APIHost = "https://api.stackexchange.com/2.2"
    }
}

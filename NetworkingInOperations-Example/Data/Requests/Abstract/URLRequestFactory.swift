//
//  URLRequestFactory.swift
//  NetworkingInOperations-Example
//
//  Created by William Boles on 12/07/2018.
//  Copyright © 2018 William Boles. All rights reserved.
//

import Foundation

enum APIError: Error {
    case unknown
    case missingData
    case serialization
    case invalidData
}

class URLRequestFactory {
    
    private let config: RequestConfig
    
    // MARK: - Init
    
    init(config: RequestConfig = RequestConfig()) {
        self.config = config
    }
    
    // MARK: - Factory
    
    func baseRequest(endPoint: String) -> URLRequest {
        let stringURL = "\(config.APIHost)/\(endPoint)"
        let encodedStringURL = stringURL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        let url = URL(string: encodedStringURL!)!
    
        return  URLRequest(url: url)
    }
    
    func jsonRequest(endPoint: String) -> URLRequest {
        var request = baseRequest(endPoint: endPoint)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        return request
    }
}

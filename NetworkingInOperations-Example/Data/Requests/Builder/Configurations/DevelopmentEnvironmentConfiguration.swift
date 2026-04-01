//
//  DevelopmentEnvironmentConfiguration.swift
//  MakingRequests-Example
//
//  Created by William Boles on 03/03/2026.
//  Copyright © 2026 Boles. All rights reserved.
//

import Foundation

struct DevelopmentEnvironmentConfiguration: EnvironmentConfiguration {
    let urlComponents: URLComponents = {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.stackexchange.com"
        
        return components
    }()
    
    let headers: [String: String] = {
        var headers = [String: String]()
        
        headers["Content-Type"] = "application/json"
        headers["Accept"] = "application/json"
        
        return headers
    }()
    
    let cachePolicy: URLRequest.CachePolicy = {
        return .reloadIgnoringLocalCacheData
    }()
    
    let timeoutInterval: TimeInterval = {
        return 120
    }()
}

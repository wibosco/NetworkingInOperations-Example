//
//  URLRequestBuilder.swift
//  MakingRequests-Example
//
//  Created by William Boles on 03/03/2026.
//  Copyright © 2026 Boles. All rights reserved.
//

import Foundation

enum HTTPMethod: String, Equatable {
    case GET
    case POST
    case DELETE
    case PUT
    case PATCH
}

final class URLRequestBuilder {
    let configuration: EnvironmentConfiguration
    
    private var components: URLComponents
    private var method: HTTPMethod = .GET
    private var headers: [String: String]
    private var body: Data?
    private var cachePolicy: URLRequest.CachePolicy
    private var timeoutInterval: TimeInterval
    
    private var hasBuilt = false
    
    // MARK: - Init
    
    init(configuration: EnvironmentConfiguration) {
        self.configuration = configuration
        
        self.components = configuration.urlComponents
        self.headers = configuration.headers
        self.cachePolicy = configuration.cachePolicy
        self.timeoutInterval = configuration.timeoutInterval
    }
    
    // MARK: - Configuration
    
    func path(_ path: String) -> Self {
        components.path = path
        
        return self
    }
    
    func method(_ method: HTTPMethod) -> Self {
        self.method = method
        
        return self
    }
    
    func body(_ body: Data) -> Self {
        self.body = body
        
        return self
    }
    
    func queryItems(_ queryItems: [URLQueryItem]) -> Self {
        components.queryItems = queryItems.isEmpty ? nil : queryItems
        
        return self
    }
    
    func header(key: String, value: String) -> Self {
        headers[key] = value
        
        return self
    }
    
    func headers(_ headers: [String: String]) -> Self {
        self.headers.merge(headers) { _, new in new }
        
        return self
    }

    func cachePolicy(_ cachePolicy: URLRequest.CachePolicy) -> Self {
        self.cachePolicy = cachePolicy
        
        return self
    }
    
    func timeoutInterval(_ timeoutInterval: TimeInterval) -> Self {
        self.timeoutInterval = timeoutInterval
        
        return self
    }
    
    // MARK: - Build
    
    func build() throws -> URLRequest {
        guard !hasBuilt else {
            preconditionFailure("Builder.build() must only be called once. Create a new builder for each request.")
        }
        
        hasBuilt = true
        
        guard let url = components.url else {
            throw URLRequestBuildingError.urlInvalid
        }
        
        var request = URLRequest(url: url,
                                 cachePolicy: cachePolicy,
                                 timeoutInterval: timeoutInterval)
        
        request.httpMethod = method.rawValue
        request.allHTTPHeaderFields = headers
        request.httpBody = body
        
        return request
    }
}

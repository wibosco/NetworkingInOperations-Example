//
//  URLSessionType.swift
//  NetworkingInOperations-Example
//
//  Created by William Boles on 02/04/2026.
//  Copyright © 2026 Boles. All rights reserved.
//

import Foundation

protocol URLSessionType {
    func dataTask(with request: URLRequest,
                  completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskType
}

extension URLSession: URLSessionType {
    func dataTask(with request: URLRequest,
                  completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskType {
        return (dataTask(with: request,
                         completionHandler: completionHandler) as URLSessionDataTask) as URLSessionDataTaskType
    }
}

protocol URLSessionDataTaskType {
    func resume()
    func cancel()
}

extension URLSessionDataTask: URLSessionDataTaskType {}

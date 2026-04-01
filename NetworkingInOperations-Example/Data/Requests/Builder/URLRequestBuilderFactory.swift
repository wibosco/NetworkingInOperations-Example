//
//  URLRequestBuilderFactory.swift
//  MakingRequests-Example
//
//  Created by William Boles on 03/03/2026.
//  Copyright © 2026 Boles. All rights reserved.
//

import Foundation

protocol URLRequestBuildingFactory {
    func createBuilder() -> URLRequestBuilder
}

struct URLRequestBuilderFactory: URLRequestBuildingFactory {
    func createBuilder() -> URLRequestBuilder {
        return URLRequestBuilder(configuration: DevelopmentEnvironmentConfiguration())
    }
}

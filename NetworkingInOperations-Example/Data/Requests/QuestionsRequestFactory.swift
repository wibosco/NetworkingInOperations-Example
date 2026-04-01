//
//  QuestionsURLRequestFactory.swift
//  NetworkingInOperations-Example
//
//  Created by William Boles on 29/07/2018.
//  Copyright © 2018 Boles. All rights reserved.
//

import Foundation

class QuestionsRequestFactory {
    
    private let urlRequestBuilderFactory: URLRequestBuildingFactory
    
    // MARK: - Init
    
    init(urlRequestBuilderFactory: URLRequestBuildingFactory = URLRequestBuilderFactory()) {
        self.urlRequestBuilderFactory = urlRequestBuilderFactory
    }
    
    // MARK: - Retrieval
    
    func createQuestionsGetRequest(pageIndex: Int) throws -> URLRequest {
        var queryItems = [
            URLQueryItem(name: "order", value: "desc"),
            URLQueryItem(name: "sort", value: "activity"),
            URLQueryItem(name: "tagged", value: "ios"),
            URLQueryItem(name: "pagesize", value: "30"),
            URLQueryItem(name: "site", value: "stackoverflow"),
        ]
        
        if pageIndex > 0 {
            queryItems.append(URLQueryItem(name: "page", value: "\(pageIndex)"))
        }
        
        return try urlRequestBuilderFactory.createBuilder()
            .path("/2.2/questions")
            .method(.GET)
            .queryItems(queryItems)
            .build()
    }
}

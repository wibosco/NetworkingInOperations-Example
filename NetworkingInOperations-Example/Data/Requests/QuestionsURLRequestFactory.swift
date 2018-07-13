//
//  QuestionsURLRequestFactory.swift
//  NetworkingInOperations-Example
//
//  Created by William Boles on 29/07/2018.
//  Copyright © 2018 Boles. All rights reserved.
//

import Foundation

class QuestionsURLRequestFactory: URLRequestFactory {
    
    // MARK: - Retrieval
    
    func requestToRetrieveQuestions() -> URLRequest {
        var request = jsonRequest(endPoint: "questions?order=desc&sort=activity&tagged=ios&site=stackoverflow")
        request.httpMethod = HTTPRequestMethod.get.rawValue
        
        return request
    }
}

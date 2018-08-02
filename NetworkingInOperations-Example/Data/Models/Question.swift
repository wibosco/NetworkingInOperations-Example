//
//  Question.swift
//  NetworkingInOperations-Example
//
//  Created by William Boles on 29/07/2018.
//  Copyright © 2018 Boles. All rights reserved.
//

import Foundation

private struct DummyCodable: Codable {}

struct QuestionPage: Codable {
    
    let questions: [Question]
    
    // MARK: - CodingKeys
    
    enum CodingKeys: String, CodingKey {
        case questions = "items"
    }
    
    // MARK: - Init
    
    init(from decoder: Decoder) throws {        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        questions = try container.decodeArrayByIgnoringInvalidElements(Question.self, forKey: .questions)
    }
}

struct Question: Codable {
    
    let questionID: Int
    let title: String
    let user: User
    
    // MARK: - CodingKeys
    
    enum CodingKeys: String, CodingKey {
        case questionID = "question_id"
        case title = "title"
        case user = "owner"
    }
}

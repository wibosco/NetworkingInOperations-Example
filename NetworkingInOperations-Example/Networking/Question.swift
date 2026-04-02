//
//  Question.swift
//  NetworkingInOperations-Example
//
//  Created by William Boles on 29/07/2018.
//  Copyright © 2018 Boles. All rights reserved.
//

import Foundation

struct QuestionPage: Codable {
    let items: [Question]
}

struct Question: Codable {
    let questionID: Int
    let title: String
    
    // MARK: - CodingKeys
    
    enum CodingKeys: String, CodingKey {
        case questionID = "question_id"
        case title = "title"
    }
}

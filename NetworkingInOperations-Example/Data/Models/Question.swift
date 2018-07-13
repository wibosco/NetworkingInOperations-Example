//
//  Question.swift
//  NetworkingInOperations-Example
//
//  Created by William Boles on 29/07/2018.
//  Copyright © 2018 Boles. All rights reserved.
//

import Foundation

struct QuestionPage: Codable {
    let questions: [Question]
    
    enum CodingKeys: String, CodingKey {
        case questions = "items"
    }
}

struct Question: Codable {
    let questionID: Int
    let title: String
    let user: User
    
    enum CodingKeys: String, CodingKey {
        case questionID = "question_id"
        case title = "title"
        case user = "owner"
    }
}

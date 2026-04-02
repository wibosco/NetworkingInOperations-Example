//
//  QuestionTests.swift
//  NetworkingInOperations-ExampleTests
//
//  Created by William Boles on 02/04/2026.
//  Copyright © 2026 Boles. All rights reserved.
//

import XCTest

@testable import NetworkingInOperations_Example

final class QuestionTests: XCTestCase {
    
    // MARK: - Tests
    
    func test_givenValidJSON_whenDecodingQuestion_thenPropertiesAreMapped() throws {
        let json = """
            {
                "question_id": 123,
                "title": "How do I parse JSON in Swift?"
            }
            """.data(using: .utf8)!
        
        let question = try JSONDecoder().decode(Question.self, from: json)
        
        XCTAssertEqual(question.questionID, 123)
        XCTAssertEqual(question.title, "How do I parse JSON in Swift?")
    }
    
    func test_givenMissingTitle_whenDecodingQuestion_thenDecodingFails() {
        let json = """
            {
                "question_id": 123
            }
            """.data(using: .utf8)!
        
        XCTAssertThrowsError(try JSONDecoder().decode(Question.self, from: json))
    }
    
    func test_givenMissingQuestionID_whenDecodingQuestion_thenDecodingFails() {
        let json = """
            {
                "title": "How do I parse JSON in Swift?"
            }
            """.data(using: .utf8)!
        
        XCTAssertThrowsError(try JSONDecoder().decode(Question.self, from: json))
    }
    
    func test_givenExtraUnknownKeys_whenDecodingQuestion_thenUnknownKeysAreIgnored() throws {
        let json = """
            {
                "question_id": 123,
                "title": "How do I parse JSON in Swift?",
                "view_count": 5000,
                "answer_count": 3
            }
            """.data(using: .utf8)!
        
        let question = try JSONDecoder().decode(Question.self, from: json)
        
        XCTAssertEqual(question.questionID, 123)
        XCTAssertEqual(question.title, "How do I parse JSON in Swift?")
    }
    
    func test_givenInvalidQuestionIDType_whenDecodingQuestion_thenDecodingFails() {
        let json = """
            {
                "question_id": "not_a_number",
                "title": "How do I parse JSON in Swift?"
            }
            """.data(using: .utf8)!
        
        XCTAssertThrowsError(try JSONDecoder().decode(Question.self, from: json))
    }
    
}

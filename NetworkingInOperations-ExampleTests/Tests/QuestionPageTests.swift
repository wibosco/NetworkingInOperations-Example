//
//  QuestionPageTests.swift
//  NetworkingInOperations-ExampleTests
//
//  Created by William Boles on 02/04/2026.
//  Copyright © 2026 Boles. All rights reserved.
//

import XCTest

@testable import NetworkingInOperations_Example

final class QuestionPageTests: XCTestCase {

    // MARK: - Tests
    
    func test_givenValidJSON_whenDecodingQuestionPage_thenQuestionsAreDecoded() throws {
        let json = """
            {
                "items": [
                    {
                        "question_id": 123,
                        "title": "How do I parse JSON in Swift?"
                    },
                    {
                        "question_id": 456,
                        "title": "What is a closure?"
                    }
                ],
                "has_more": true,
                "quota_max": 300,
                "quota_remaining": 299
            }
            """.data(using: .utf8)!
        
        let page = try JSONDecoder().decode(QuestionPage.self, from: json)
        
        XCTAssertEqual(page.items.count, 2)
    }
    
    func test_givenEmptyItemsArray_whenDecodingQuestionPage_thenQuestionsIsEmpty() throws {
        let json = """
            {
                "items": [],
                "has_more": false,
                "quota_max": 300,
                "quota_remaining": 300
            }
            """.data(using: .utf8)!
        
        let page = try JSONDecoder().decode(QuestionPage.self, from: json)
        
        XCTAssertTrue(page.items.isEmpty)
    }
    
    func test_givenMissingItemsKey_whenDecodingQuestionPage_thenDecodingFails() {
        let json = """
            {
                "has_more": false,
                "quota_max": 300
            }
            """.data(using: .utf8)!
        
        XCTAssertThrowsError(try JSONDecoder().decode(QuestionPage.self, from: json))
    }
    
    func test_givenExtraUnknownKeys_whenDecodingQuestionPage_thenUnknownKeysAreIgnored() throws {
        let json = """
            {
                "items": [
                    {
                        "question_id": 789,
                        "title": "What is SwiftUI?"
                    }
                ],
                "has_more": true,
                "quota_max": 300,
                "quota_remaining": 299,
                "some_unexpected_key": "some_value"
            }
            """.data(using: .utf8)!
        
        let page = try JSONDecoder().decode(QuestionPage.self, from: json)
        
        XCTAssertEqual(page.items.count, 1)
    }

}

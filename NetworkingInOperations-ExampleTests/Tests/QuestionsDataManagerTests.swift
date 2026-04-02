//
//  QuestionsDataManagerTests.swift
//  NetworkingInOperations-ExampleTests
//
//  Created by William Boles on 02/04/2026.
//  Copyright © 2026 Boles. All rights reserved.
//

import XCTest

@testable import NetworkingInOperations_Example

// MARK: - Tests

final class QuestionsDataManagerTests: XCTestCase {
    private var queue: StubOperationQueue!
    private var sut: QuestionsDataManager!

    // MARK: - Lifecycle

    override func setUp() {
        super.setUp()

        queue = StubOperationQueue()

        sut = QuestionsDataManager(queue: queue)
    }

    override func tearDown() {
        sut = nil
        queue = nil

        super.tearDown()
    }

    // MARK: - Tests

    func test_givenManager_whenRetrievingQuestions_thenOperationIsAddedToQueue() {
        sut.fetchQuestions { _ in }

        XCTAssertEqual(queue.events.count, 1)
    }

    func test_givenManager_whenRetrievingQuestions_thenOperationIsQuestionsRetrievalOperation() {
        sut.fetchQuestions { _ in }
        
        guard case .addOperation(let operation) = queue.events[0] else {
            XCTFail("Unexpected event")
            return
        }
        
        XCTAssertTrue(operation is QuestionsFetchOperation)
    }

    func test_givenManager_whenRetrievingQuestionsMultipleTimes_thenEachCallAddsAnOperation() {
        sut.fetchQuestions { _ in }
        sut.fetchQuestions { _ in }
        sut.fetchQuestions { _ in }

        XCTAssertEqual(queue.events.count, 3)
    }
}

//
//  ConcurrentOperationTests.swift
//  CoalescingOperationsReducedBoilerplate-Example
//
//  Created by William Boles on 04/09/2016.
//  Copyright © 2016 Boles. All rights reserved.
//

import Foundation
import XCTest

@testable import NetworkingInOperations_Example

final class ConcurrentOperationTests: XCTestCase {
    
    // MARK: - Tests
    
    // MARK: - Initial State

    func test_givenNewOperation_whenCheckingState_thenIsReady() {
        let operation = ConcurrentOperation<String> { _ in }

        XCTAssertTrue(operation.isReady)
        XCTAssertFalse(operation.isExecuting)
        XCTAssertFalse(operation.isFinished)
    }

    func test_givenNewOperation_whenCheckingIsAsynchronous_thenIsTrue() {
        let operation = ConcurrentOperation<String> { _ in }

        XCTAssertTrue(operation.isAsynchronous)
    }

    // MARK: - Start

    func test_givenReadyOperation_whenStarted_thenIsExecuting() {
        let operation = ConcurrentOperation<String> { _ in }

        operation.start()

        XCTAssertTrue(operation.isExecuting)
        XCTAssertFalse(operation.isReady)
        XCTAssertFalse(operation.isFinished)
    }

    func test_givenCancelledOperation_whenStarted_thenCompletionHandlerIsCalledWithCancelledError() {
        let expectation = expectation(description: "Completion handler called")
        var receivedResult: Result<String, Error>?

        let operation = ConcurrentOperation<String> { result in
            receivedResult = result
            
            expectation.fulfill()
        }

        operation.cancel()
        operation.start()

        wait(for: [expectation], timeout: 1.0)

        switch receivedResult {
        case .failure(let error as ConcurrentOperationError):
            XCTAssertEqual(error, .cancelled)
        default:
            XCTFail("Expected cancelled error")
        }
    }

    func test_givenCancelledOperation_whenStarted_thenIsFinished() {
        let operation = ConcurrentOperation<String> { _ in }

        operation.cancel()
        operation.start()

        XCTAssertTrue(operation.isFinished)
        XCTAssertFalse(operation.isExecuting)
    }

    // MARK: - Finish

    func test_givenExecutingOperation_whenFinishedWithSuccess_thenCompletionHandlerReceivesValue() {
        let expectation = expectation(description: "Completion handler called")
        var receivedResult: Result<String, Error>?

        let operation = ConcurrentOperation<String> { result in
            receivedResult = result
            
            expectation.fulfill()
        }

        operation.start()
        operation.finish(result: .success("done"))

        wait(for: [expectation], timeout: 1.0)

        switch receivedResult {
        case .success(let value):
            XCTAssertEqual(value, "done")
        default:
            XCTFail("Expected success result")
        }
    }

    func test_givenExecutingOperation_whenFinishedWithFailure_thenCompletionHandlerReceivesError() {
        let expectation = expectation(description: "Completion handler called")
        var receivedResult: Result<String, Error>?

        let operation = ConcurrentOperation<String> { result in
            receivedResult = result
            
            expectation.fulfill()
        }

        operation.start()
        operation.finish(result: .failure(NSError(domain: "test", code: 1)))

        wait(for: [expectation], timeout: 1.0)

        switch receivedResult {
        case .failure(let error as NSError):
            XCTAssertEqual(error.domain, "test")
            XCTAssertEqual(error.code, 1)
        default:
            XCTFail("Expected failure result")
        }
    }

    func test_givenExecutingOperation_whenFinished_thenIsFinished() {
        let operation = ConcurrentOperation<String> { _ in }

        operation.start()
        operation.finish(result: .success("done"))

        XCTAssertTrue(operation.isFinished)
        XCTAssertFalse(operation.isExecuting)
    }

    func test_givenFinishedOperation_whenFinishedAgain_thenCompletionHandlerIsNotCalledAgain() {
        var callCount = 0

        let operation = ConcurrentOperation<String> { _ in
            callCount += 1
        }

        operation.start()
        operation.finish(result: .success("first"))
        operation.finish(result: .success("second"))

        XCTAssertEqual(callCount, 1)
    }

    // MARK: - Cancel

    func test_givenExecutingOperation_whenCancelled_thenCompletionHandlerIsCalledWithCancelledError() {
        let expectation = expectation(description: "Completion handler called")
        var receivedResult: Result<String, Error>?

        let operation = ConcurrentOperation<String> { result in
            receivedResult = result
            
            expectation.fulfill()
        }

        operation.start()
        operation.cancel()

        wait(for: [expectation], timeout: 1.0)

        switch receivedResult {
        case .failure(let error as ConcurrentOperationError):
            XCTAssertEqual(error, .cancelled)
        default:
            XCTFail("Expected cancelled error")
        }
    }

    func test_givenExecutingOperation_whenCancelled_thenIsFinished() {
        let operation = ConcurrentOperation<String> { _ in }

        operation.start()
        operation.cancel()

        XCTAssertTrue(operation.isFinished)
        XCTAssertTrue(operation.isCancelled)
    }

    // MARK: - KVO

    func test_givenReadyOperation_whenStarted_thenKVONotificationsAreFired() {
        let operation = ConcurrentOperation<String> { _ in }

        let executingExpectation = keyValueObservingExpectation(for: operation,
                                                                keyPath: "isExecuting",
                                                                expectedValue: true)

        operation.start()

        wait(for: [executingExpectation], timeout: 1.0)
    }

    func test_givenExecutingOperation_whenFinished_thenKVONotificationsAreFired() {
        let operation = ConcurrentOperation<String> { _ in }
        operation.start()

        let finishedExpectation = keyValueObservingExpectation(for: operation,
                                                               keyPath: "isFinished",
                                                               expectedValue: true)

        operation.finish(result: .success("done"))

        wait(for: [finishedExpectation], timeout: 1.0)
    }

    // MARK: - OperationQueue

    func test_givenOperation_whenAddedToQueue_thenMainIsCalled() {
        let expectation = expectation(description: "Completion handler called")

        let operation = ConcurrentOperation<String> { _ in
            expectation.fulfill()
        }

        let queue = OperationQueue()
        queue.addOperation(operation)

        // Simulate finishing from main() — in a real subclass, main() would call finish
        DispatchQueue.global().asyncAfter(deadline: .now() + 0.1) {
            operation.finish(result: .success("done"))
        }

        wait(for: [expectation], timeout: 2.0)

        XCTAssertTrue(operation.isFinished)
    }

    // MARK: - Generic Value

    func test_givenIntOperation_whenFinishedWithSuccess_thenCompletionHandlerReceivesInt() {
        let expectation = expectation(description: "Completion handler called")
        var receivedValue: Int?

        let operation = ConcurrentOperation<Int> { result in
            if case .success(let value) = result {
                receivedValue = value
            }
            
            expectation.fulfill()
        }

        operation.start()
        operation.finish(result: .success(42))

        wait(for: [expectation], timeout: 1.0)

        XCTAssertEqual(receivedValue, 42)
    }
}
    
    

//
//  QuestionsRetrievalOperationTests.swift
//  NetworkingInOperations-ExampleTests
//
//  Created by William Boles on 02/04/2026.
//  Copyright © 2026 Boles. All rights reserved.
//

import XCTest

@testable import NetworkingInOperations_Example

final class QuestionsRetrievalOperationTests: XCTestCase {
    private var session: StubURLSession!
    private var dataTask: StubURLSessionDataTask!
    private var decoder: StubJSONDecoder!
    private var sut: QuestionsFetchOperation!

    private var completionResult: Result<[Question], Error>?

    private let successResponse = HTTPURLResponse(url: URL(string: "https://api.stackexchange.com")!,
                                                  statusCode: 200,
                                                  httpVersion: nil,
                                                  headerFields: nil)

    // MARK: - Lifecycle

    override func setUp() {
        super.setUp()

        session = StubURLSession()
        dataTask = StubURLSessionDataTask()
        decoder = StubJSONDecoder()

        session.dataTask = dataTask

        sut = QuestionsFetchOperation(session: session,
                                          decoder: decoder) { result in
            self.completionResult = result
        }
    }

    override func tearDown() {
        sut = nil
        decoder = nil
        dataTask = nil
        session = nil
        completionResult = nil

        super.tearDown()
    }

    // MARK: - Tests

    // MARK: Request

    func test_givenOperation_whenStarted_thenDataTaskIsCreatedWithExpectedURL() {
        sut.start()

        guard case .dataTask(let request, _) = session.events.first else {
            XCTFail("Expected dataTask event")
            return
        }

        XCTAssertEqual(request.url?.absoluteString, "https://api.stackexchange.com/2.3/questions?site=stackoverflow")
    }

    func test_givenOperation_whenStarted_thenDataTaskIsResumed() {
        sut.start()

        XCTAssertEqual(dataTask.events, [.resume])
    }

    // MARK: Success

    func test_givenOperation_whenDataTaskReturnsData_thenDataIsDecoded() {
        let questions = [Question(questionID: 123, title: "Test")]
        decoder.decodeResult = .success(QuestionPage(items: questions))

        sut.start()

        let data = Data("{}".utf8)
        guard case .dataTask(_, let handler) = session.events.first else {
            XCTFail("Expected dataTask event")
            return
        }
        handler(data, successResponse, nil)

        guard case .decode(_, let receivedData) = decoder.events.first else {
            XCTFail("Expected decode event")
            return
        }

        XCTAssertEqual(receivedData, data)
    }

    func test_givenOperation_whenDecodingSucceeds_thenCompletionHandlerReceivesQuestions() {
        let questions = [Question(questionID: 123, title: "Test")]
        decoder.decodeResult = .success(QuestionPage(items: questions))

        sut.start()

        guard case .dataTask(_, let handler) = session.events.first else {
            XCTFail("Expected dataTask event")
            return
        }
        handler(Data("{}".utf8), successResponse, nil)

        switch completionResult {
        case .success(let receivedQuestions):
            XCTAssertEqual(receivedQuestions.count, 1)
            XCTAssertEqual(receivedQuestions.first?.questionID, 123)
            XCTAssertEqual(receivedQuestions.first?.title, "Test")
        default:
            XCTFail("Expected success result")
        }
    }

    // MARK: Failure

    func test_givenOperation_whenDataTaskReturnsNilDataWithError_thenCompletionHandlerReceivesThatError() {
        sut.start()

        guard case .dataTask(_, let handler) = session.events.first else {
            XCTFail("Expected dataTask event")
            return
        }

        let error = NSError(domain: "test", code: 42)
        handler(nil, nil, error)

        switch completionResult {
        case .failure(let receivedError as NSError):
            XCTAssertEqual(receivedError.domain, "test")
            XCTAssertEqual(receivedError.code, 42)
        default:
            XCTFail("Expected failure result")
        }
    }

    func test_givenOperation_whenDataTaskReturnsNilDataWithoutError_thenCompletionHandlerReceivesMissingDataError() {
        sut.start()

        guard case .dataTask(_, let handler) = session.events.first else {
            XCTFail("Expected dataTask event")
            return
        }
        handler(nil, nil, nil)

        switch completionResult {
        case .failure(let receivedError as NetworkingError):
            XCTAssertEqual(receivedError, .missingData)
        default:
            XCTFail("Expected missingData error")
        }
    }

    func test_givenOperation_whenDecodingFails_thenCompletionHandlerReceivesSerializationError() {
        decoder.decodeResult = .failure(NSError(domain: "decoding", code: 1))

        sut.start()

        guard case .dataTask(_, let handler) = session.events.first else {
            XCTFail("Expected dataTask event")
            return
        }
        handler(Data("{}".utf8), successResponse, nil)

        switch completionResult {
        case .failure(let receivedError as NetworkingError):
            XCTAssertEqual(receivedError, .serialization)
        default:
            XCTFail("Expected serialization error")
        }
    }

    func test_givenOperation_whenDataTaskReturnsNonHTTPResponse_thenCompletionHandlerReceivesMissingDataError() {
        sut.start()

        guard case .dataTask(_, let handler) = session.events.first else {
            XCTFail("Expected dataTask event")
            return
        }

        let nonHTTPResponse = URLResponse(url: URL(string: "https://api.stackexchange.com")!,
                                          mimeType: nil,
                                          expectedContentLength: 0,
                                          textEncodingName: nil)
        handler(Data("{}".utf8), nonHTTPResponse, nil)

        switch completionResult {
        case .failure(let receivedError as NetworkingError):
            XCTAssertEqual(receivedError, .missingData)
        default:
            XCTFail("Expected missingData error")
        }
    }

    func test_givenOperation_whenDataTaskReturnsNon200StatusCode_thenCompletionHandlerReceivesInvalidStatusCodeError() {
        sut.start()

        guard case .dataTask(_, let handler) = session.events.first else {
            XCTFail("Expected dataTask event")
            return
        }

        let errorResponse = HTTPURLResponse(url: URL(string: "https://api.stackexchange.com")!,
                                            statusCode: 500,
                                            httpVersion: nil,
                                            headerFields: nil)
        handler(Data("{}".utf8), errorResponse, nil)

        switch completionResult {
        case .failure(let receivedError as NetworkingError):
            XCTAssertEqual(receivedError, .invalidStatusCode(500))
        default:
            XCTFail("Expected invalidStatusCode error")
        }
    }

    func test_givenOperation_whenDataTaskReturnsEmptyData_thenCompletionHandlerReceivesMissingDataError() {
        sut.start()

        guard case .dataTask(_, let handler) = session.events.first else {
            XCTFail("Expected dataTask event")
            return
        }
        handler(Data(), successResponse, nil)

        switch completionResult {
        case .failure(let receivedError as NetworkingError):
            XCTAssertEqual(receivedError, .missingData)
        default:
            XCTFail("Expected missingData error")
        }
    }

    // MARK: Cancel

    func test_givenRunningOperation_whenCancelled_thenDataTaskIsCancelled() {
        sut.start()
        sut.cancel()

        XCTAssertTrue(dataTask.events.contains(.cancel))
    }
}

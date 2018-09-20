//
//  QuestionsRetrievalOperation.swift
//  NetworkingInOperations-Example
//
//  Created by William Boles on 29/07/2018.
//  Copyright © 2018 Boles. All rights reserved.
//

import Foundation

class QuestionsRetrievalOperation: ConcurrentOperation<QuestionPage> {
    
    private let session: URLSession
    private let urlRequestFactory: QuestionsURLRequestFactory
    private var task: URLSessionTask?
    private let pageIndex: Int
    
    // MARK: - Init
    
    init(pageIndex: Int, session: URLSession = URLSession.shared, urlRequestFactory: QuestionsURLRequestFactory = QuestionsURLRequestFactory()) {
        self.pageIndex = pageIndex
        self.session = session
        self.urlRequestFactory = urlRequestFactory
    }
    
    // MARK: - Main
    
    override func main() {
        let urlRequest = urlRequestFactory.requestToRetrieveQuestions(pageIndex: pageIndex)
        
        task = session.dataTask(with: urlRequest) { (data, response, error) in
            guard let data = data else {
                DispatchQueue.main.async {
                    if let error = error {
                        self.complete(result: .failure(error))
                    } else {
                        self.complete(result: .failure(APIError.missingData))
                    }
                }
                return
            }
            
            do {
                let page = try JSONDecoder().decode(QuestionPage.self, from: data)
                
                DispatchQueue.main.async {
                    self.complete(result: .success(page))
                }
            } catch let error {
                DispatchQueue.main.async {
                    print(error)
                    self.complete(result: .failure(APIError.serialization))
                }
            }
        }
        
        task?.resume()
    }
    
    // MARK: - Cancel
    
    override func cancel() {
        task?.cancel()
        super.cancel()
    }
}

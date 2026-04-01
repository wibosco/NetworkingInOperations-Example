//
//  QuestionsRetrievalOperation.swift
//  NetworkingInOperations-Example
//
//  Created by William Boles on 29/07/2018.
//  Copyright © 2018 Boles. All rights reserved.
//

import Foundation

class QuestionsRetrievalOperation: ConcurrentOperation<QuestionPage>, @unchecked Sendable {
    private let session: URLSession
    private let urlRequestFactory: QuestionsRequestFactory
    private var task: URLSessionTask?
    private let pageIndex: Int
    
    // MARK: - Init
    
    init(pageIndex: Int,
         session: URLSession = URLSession.shared,
         urlRequestFactory: QuestionsRequestFactory = QuestionsRequestFactory(),
         completionHandler: @escaping (_ result: Result<QuestionPage, Error>) -> Void) {
        self.pageIndex = pageIndex
        self.session = session
        self.urlRequestFactory = urlRequestFactory
        
        super.init(completionHandler: completionHandler)
    }
    
    // MARK: - Main
    
    override func main() {
        // TODO: Remove !
        guard let urlRequest = try? urlRequestFactory.createQuestionsGetRequest(pageIndex: pageIndex) else {
            self.finish(result: .failure(APIError.invalidRequest))
            return
        }
        
        task = session.dataTask(with: urlRequest) { (data, response, error) in
            guard let data = data else {
                DispatchQueue.main.async {
                    if let error = error {
                        self.finish(result: .failure(error))
                    } else {
                        self.finish(result: .failure(APIError.missingData))
                    }
                }
                return
            }
            
            do {
                let page = try JSONDecoder().decode(QuestionPage.self, from: data)
                
                DispatchQueue.main.async {
                    self.finish(result: .success(page))
                }
            } catch let error {
                DispatchQueue.main.async {
                    print(error)
                    self.finish(result: .failure(APIError.serialization))
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

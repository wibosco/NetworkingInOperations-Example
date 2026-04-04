//
//  QuestionsRetrievalOperation.swift
//  NetworkingInOperations-Example
//
//  Created by William Boles on 29/07/2018.
//  Copyright © 2018 Boles. All rights reserved.
//

import Foundation

class QuestionsFetchOperation: ConcurrentOperation<[Question]>, @unchecked Sendable {
    private var session: URLSessionType
    private var decoder: JSONDecoderType
    private var task: URLSessionDataTaskType?
    
    // MARK: - Init
    
    init(session: URLSessionType = URLSession.shared,
         decoder: JSONDecoderType = JSONDecoder(),
         completionHandler: @escaping (_ result: Result<[Question], Error>) -> Void) {
        self.session = session
        self.decoder = decoder
        
        super.init(completionHandler: completionHandler)
    }
    
    // MARK: - Main
    
    override func main() {
        let url = URL(string: "https://api.stackexchange.com/2.3/questions?site=stackoverflow")!
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        
        task = session.dataTask(with: urlRequest) { (data, response, error) in
            if let error = error {
                self.finish(result: .failure(error))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                self.finish(result: .failure(NetworkingError.missingData))
                return
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                self.finish(result: .failure(NetworkingError.invalidStatusCode(httpResponse.statusCode)))
                return
            }
            
            guard let data = data, !data.isEmpty else {
                self.finish(result: .failure(NetworkingError.missingData))
                return
            }
            
            do {
                let questionPage = try self.decoder.decode(QuestionPage.self,
                                                           from: data)
                
                self.finish(result: .success(questionPage.items))
            } catch {
                self.finish(result: .failure(NetworkingError.serialization))
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

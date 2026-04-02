//
//  QuestionsDataManager.swift
//  NetworkingInOperations-Example
//
//  Created by William Boles on 29/07/2018.
//  Copyright © 2018 Boles. All rights reserved.
//

import Foundation

class QuestionsDataManager {
    private let queue: OperationQueueType
    
    // MARK: - Init
    
    init(queue: OperationQueueType) {
        self.queue = queue
    }
    
    // MARK: - Retrieval
    
    func fetchQuestions(completionHandler: @escaping (_ result: Result<[Question], Error>) -> Void) {
        let operation = QuestionsFetchOperation(completionHandler: completionHandler)

        queue.addOperation(operation)
    }
}

//
//  QuestionsDataManager.swift
//  NetworkingInOperations-Example
//
//  Created by William Boles on 29/07/2018.
//  Copyright © 2018 Boles. All rights reserved.
//

import Foundation

class QuestionsDataManager {
    private let queueManager: OperationQueueManager
    
    // MARK: - Init
    
    init(withQueueManager queueManager: OperationQueueManager = OperationQueueManager.shared) {
        self.queueManager = queueManager
    }
    
    // MARK: - Retrieval
    
    func retrievalQuestions(pageIndex: Int,
                            completionHandler: @escaping (_ result: Result<QuestionPage, Error>) -> Void) {
        let operation = QuestionsRetrievalOperation(pageIndex: pageIndex,
                                                    completionHandler: completionHandler)

        queueManager.enqueue(operation)
    }
}

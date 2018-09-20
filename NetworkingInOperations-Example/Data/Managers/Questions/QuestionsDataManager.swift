//
//  QuestionsDataManager.swift
//  NetworkingInOperations-Example
//
//  Created by William Boles on 29/07/2018.
//  Copyright © 2018 Boles. All rights reserved.
//

import Foundation

class QuestionsDataManager {
    
    private let queueManager: QueueManager
    
    // MARK: - Init
    
    init(withQueueManager queueManager: QueueManager = QueueManager.shared) {
        self.queueManager = queueManager
    }
    
    // MARK: - Retrieval
    
    func retrievalQuestions(pageIndex: Int, completionHandler: @escaping (_ result: Result<QuestionPage>) -> Void) {
        let operation = QuestionsRetrievalOperation(pageIndex: pageIndex)
        operation.completionHandler = completionHandler
        queueManager.enqueue(operation)
    }
}

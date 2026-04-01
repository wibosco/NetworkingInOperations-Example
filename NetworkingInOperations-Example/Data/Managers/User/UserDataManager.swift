//
//  UserDataManager.swift
//  NetworkingInOperations-Example
//
//  Created by William Boles on 29/07/2018.
//  Copyright © 2018 Boles. All rights reserved.
//

import Foundation
import UIKit

class UserDataManager {
    private let queueManager: OperationQueueManager
    
    // MARK: - Init
    
    init(withQueueManager queueManager: OperationQueueManager = OperationQueueManager.shared) {
        self.queueManager = queueManager
    }
    
    // MARK: - Avatar
    
    func retrieveAvatar(forUser user: User,
                        completionHandler: @escaping (_ result: Result<(User, UIImage), Error>) -> Void) {
        let operation = AvatarRetrievalOperation(user: user,
                                                 completionHandler: completionHandler)
        
        queueManager.enqueue(operation)
    }
}

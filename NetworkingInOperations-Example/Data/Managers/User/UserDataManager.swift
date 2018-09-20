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
    
    private let queueManager: QueueManager
    
    // MARK: - Init
    
    init(withQueueManager queueManager: QueueManager = QueueManager.shared) {
        self.queueManager = queueManager
    }
    
    // MARK: - Avatar
    
    func retrieveAvatar(forUser user: User, completionHandler: @escaping (_ result: Result<(User, UIImage)>) -> Void) {
        let operation = AvatarRetrievalOperation(user: user)
        operation.completionHandler = completionHandler
        queueManager.enqueue(operation)
    }
}

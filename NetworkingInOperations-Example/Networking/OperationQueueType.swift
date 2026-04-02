//
//  OperationQueuing.swift
//  NetworkingInOperations-Example
//
//  Created by William Boles on 02/04/2026.
//  Copyright © 2026 Boles. All rights reserved.
//

import Foundation

protocol OperationQueueType {
    func addOperation(_ op: Operation)
}

extension OperationQueue: OperationQueueType { }

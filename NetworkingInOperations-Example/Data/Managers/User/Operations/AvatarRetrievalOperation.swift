//
//  AvatarRetrievalOperation.swift
//  NetworkingInOperations-Example
//
//  Created by William Boles on 29/07/2018.
//  Copyright © 2018 Boles. All rights reserved.
//

import Foundation
import UIKit

class AvatarRetrievalOperation: ConcurrentOperation<(User, UIImage)>, @unchecked Sendable  {
    private let session: URLSession
    private let user: User
    private var task: URLSessionTask?
    
    // MARK: - Init
    
    init(session: URLSession = URLSession.shared,
         user: User,
         completionHandler: @escaping (_ result: Result<(User, UIImage), Error>) -> Void) {
        self.session = session
        self.user = user
        
        super.init(completionHandler: completionHandler)
    }
    
    // MARK: - Main
    
    override func main() {
        guard let avatarURL = URL(string: user.avatarURL) else {
            cancel()
            return
        }
        
        task = session.downloadTask(with: avatarURL) { (localURL, response, error) in
            guard let localURL = localURL,
                let data = try? Data(contentsOf: localURL),
                let image = UIImage(data: data) else {
                DispatchQueue.main.async {
                    if let error = error {
                        self.finish(result: .failure(error))
                    } else {
                        self.finish(result: .failure(APIError.missingData))
                    }
                }
                return
            }
            
            DispatchQueue.main.async {
                self.finish(result: .success((self.user, image)))
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

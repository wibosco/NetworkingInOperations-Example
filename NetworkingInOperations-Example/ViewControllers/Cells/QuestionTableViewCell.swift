//
//  QuestionTableViewCell.swift
//  NetworkingInOperations-Example
//
//  Created by William Boles on 29/07/2018.
//  Copyright © 2018 Boles. All rights reserved.
//

import UIKit

class QuestionTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var avatarImageView: UIImageView!
    
    private var question: Question?
    private let userDataManager = UserDataManager()

    // MARK: - Reuse
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        question = nil
        avatarImageView.image = UIImage(named: "avatar_default")
    }
    
    // MARK: - Configure
    
    func configure(question: Question) {
        titleLabel.text = question.title
        nameLabel.text = question.user.name
        
        self.question = question
        
        userDataManager.retrieveAvatar(forUser: question.user) { [weak self] (result) in
            guard let strongSelf = self else {
                return
            }
            
            switch result {
            case .failure(_):
                strongSelf.avatarImageView.image = UIImage(named: "avatar_default")
                break
            case .success(let (user, image)):
                if strongSelf.question?.user == user {
                    strongSelf.avatarImageView.image = image
                }
            }
        }
    }
}

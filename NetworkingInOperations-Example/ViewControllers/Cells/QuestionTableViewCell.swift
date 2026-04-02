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
    
    private var question: Question?

    // MARK: - Reuse
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        question = nil
    }
    
    // MARK: - Configure
    
    func configure(question: Question) {
        titleLabel.text = question.title
    }
}

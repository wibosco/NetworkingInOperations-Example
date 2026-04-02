//
//  QuestionsViewController.swift
//  NetworkingInOperations-Example
//
//  Created by William Boles on 29/07/2018.
//  Copyright © 2018 Boles. All rights reserved.
//

import UIKit

class QuestionsViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var loadingFooterView: UIView!
    @IBOutlet weak var errorFooterView: UIView!
    
    private let questionDataManager = QuestionsDataManager(withQueue: OperationQueue())
    private var questions = [Question]()
    
    private var retrievingQuestions: Bool = false
    
    // MARK: - ViewLifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Questions"
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 120
        
        retrieveQuestions()
    }
    
    // MARK: - Questions
    
    private func retrieveQuestions() {
        guard retrievingQuestions == false else {
            return
        }
        
        retrievingQuestions = true
        tableView.tableFooterView = loadingFooterView
        
        questionDataManager.retrievalQuestions { (result) in
            self.tableView.tableFooterView = nil
            self.retrievingQuestions = false
            switch result {
            case .failure(_):
                self.tableView.tableFooterView = self.errorFooterView
            case .success(let questions):
                self.questions.append(contentsOf: questions)
                self.tableView.reloadData()
            }
        }
    }
}

// MARK: - UITableViewDataSource

extension QuestionsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return questions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "QuestionTableViewCell",
                                                       for: indexPath) as? QuestionTableViewCell else {
            fatalError()
        }
        
        let question = questions[indexPath.row]
        cell.configure(question: question)
        
        return cell
    }
}

// MARK: - UITableViewDelegate

extension QuestionsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

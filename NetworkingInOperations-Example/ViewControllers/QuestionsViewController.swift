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
    
    fileprivate let questionDataManager = QuestionsDataManager()
    fileprivate var questions = [Question]()
    
    fileprivate var pageIndex: Int = 0
    fileprivate var retrievingQuestions: Bool = false
    fileprivate var hasMoreQuestionsToBeRetrieved: Bool = true
    
    // MARK: - ViewLifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Questions"
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120
        
        retrieveQuestions(pageIndex: pageIndex)
    }
    
    // MARK: - Questions
    
    private func retrieveQuestions(pageIndex: Int) {
        guard retrievingQuestions == false else {
            return
        }
        
        retrievingQuestions = true
        tableView.tableFooterView = loadingFooterView
        questionDataManager.retrievalQuestions(pageIndex: pageIndex) { (result) in
            self.tableView.tableFooterView = nil
            self.retrievingQuestions = false
            switch result {
            case .failure(let error):
                print("ERROR: \(error)")
                self.tableView.tableFooterView = self.errorFooterView
            case .success(let page):
                self.hasMoreQuestionsToBeRetrieved = page.hasMore
                self.pageIndex += 1
                self.questions.append(contentsOf: page.questions)
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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: QuestionTableViewCell.className, for: indexPath) as? QuestionTableViewCell else {
            fatalError()
        }
        
        let question = questions[indexPath.row]
        
        cell.configure(question: question)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let row = indexPath.row
        let triggerRetrievalFromLimit = 15
        
        if hasMoreQuestionsToBeRetrieved && (triggerRetrievalFromLimit > (questions.count - row)) {
            retrieveQuestions(pageIndex: pageIndex)
        }
    }
}

// MARK: - UITableViewDelegate

extension QuestionsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

//
//  RecordsViewController.swift
//  MovieQuiz
//
//  Created by movavi_school on 11.05.2024.
//

import UIKit

class RecordsViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var recordsLabel: UILabel!
    
    // MARK: - Variables
    private var presenter: MovieQuizPresenter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = MovieQuizPresenter(recordsController: self)
        setLabelData()
        recordsLabel.layer.masksToBounds = true
        recordsLabel.layer.cornerRadius = 15
        
    }
    func setLabelData() {
        recordsLabel.text = presenter.setLabelData()
    }

}

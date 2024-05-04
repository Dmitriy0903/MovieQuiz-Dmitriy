//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by movavi_school on 17.02.2024.

import UIKit

class AlertPresenter: AlertPresenterProtocol {
    
    private weak var delegate: AlertPresenterDelegate?
    
    init(delegate: AlertPresenterDelegate?) {
        self.delegate = delegate
    }
    
    func showResult(model: AlertModel) {
        let alert = UIAlertController(title: model.title, message: model.message, preferredStyle: .alert)
        let action = UIAlertAction(title: model.buttonText, style: .default) { _ in
            model.completion()
        }
        
        alert.addAction(action)
        delegate?.present(alert, animated: true)
    }
}



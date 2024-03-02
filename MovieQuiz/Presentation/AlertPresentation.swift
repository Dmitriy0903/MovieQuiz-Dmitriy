//
//  AlertPresentation.swift
//  MovieQuiz
//
//  Created by movavi_school on 17.02.2024.


import UIKit

class AlertPresentation: AlertPresentationProtocol {
    
    private weak var delegate: AlertPresentationDelegate?
    
    init(delegate: AlertPresentationDelegate?) {
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



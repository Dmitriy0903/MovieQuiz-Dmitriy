//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by movavi_school on 03.02.2024.
//

import Foundation

protocol QuestionFactoryDelegate: AnyObject {
    func didReceiveNextQuestion(question: QuizQuestions?)
}

//
//  MovieQuizPresenter.swift
//  MovieQuiz
//
//  Created by movavi_school on 20.04.2024.
//

import UIKit
import Foundation

final class MovieQuizPresenter {
    //MARK: - Variables
    weak var viewController: MovieQuizViewController?
    var currentQuestion: QuizQuestions?
    
    var questionsIndex: Int = 0
    let questionAmount: Int = 10
    var correctAnswers: Int = 0
    
    //MARK: - Methods
    func noButtonClicked() {
        let isAnswerCorrect = checkAnswer(yesOrNo: false)
        viewController?.showAnswerResult(isCorrect: isAnswerCorrect)
    }
    
    func yesButtonClicked() {
        let isAnswerCorrect = checkAnswer(yesOrNo: true)
        viewController?.showAnswerResult(isCorrect: isAnswerCorrect)
    }
    
    func checkAnswer(yesOrNo: Bool) -> Bool {
        guard let currentQuestion else { return true }
        if yesOrNo == currentQuestion.correctAnswer {
            correctAnswers += 1
        }
        return yesOrNo == currentQuestion.correctAnswer
    }
    
    func convert(model: QuizQuestions) -> QuizStepViewModel {
        QuizStepViewModel(image: UIImage(data: model.image) ?? UIImage(),
                          questions: model.text,
                          questionNumber: String(questionsIndex + 1) + "/10")
    }
    func isLastQuestion() -> Bool {
        questionsIndex == (questionAmount - 1)
    }
    
    func resetQuestionIndex() {
        questionsIndex = 0
        correctAnswers = 0
    }
    
    func switchToNextQuestion() {
        questionsIndex += 1
    }
}

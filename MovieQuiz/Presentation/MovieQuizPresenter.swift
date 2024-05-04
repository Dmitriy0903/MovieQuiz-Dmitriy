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
    var questionsFactory: QuestionFactoryProtocol?
    var statisticService: StatisticServiceProtocol!
    var currentQuestion: QuizQuestions?
    
    var questionsIndex: Int = 0
    let questionAmount: Int = 10
    var correctAnswers: Int = 0
    
    //MARK: - Methods
    func noButtonClicked() {
        didAnswer(yesOrNo: false)
    }
    
    func yesButtonClicked() {
        didAnswer(yesOrNo: true)
    }
    
    func didAnswer(yesOrNo: Bool) {
        guard let currentQuestion else { return }
        let givenAnswer = yesOrNo
        viewController?.showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    
    func convert(model: QuizQuestions) -> QuizStepViewModel {
        QuizStepViewModel(image: UIImage(data: model.image) ?? UIImage(),
                          questions: model.text,
                          questionNumber: String(questionsIndex + 1) + "/10")
    }
    
    func didReceiveNextQuestion(question: QuizQuestions?) {
        guard let question = question else { return }
        
        currentQuestion = question
        let viewModel = convert(model: question)
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            self.viewController?.show(quiz: viewModel)
        }
    }
    
    func showNextQuestionsOrResult() {
        if isLastQuestion() {
            statisticService.store(correct: self.correctAnswers, total: self.questionAmount)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
                guard let self else { return }
                self.viewController?.getAlertResult()
            }
        } else {
            self.switchToNextQuestion()
            questionsFactory?.requestNextQuestions()
            viewController?.enabledButtons(isEnabled: true)
            }
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

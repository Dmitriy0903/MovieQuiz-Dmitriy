//
//  MovieQuizPresenter.swift
//  MovieQuiz
//
//  Created by movavi_school on 20.04.2024.
//

import UIKit

final class MovieQuizPresenter {
    //MARK: - Variables
    weak var viewController: MovieQuizViewController?
    private var questionsFactory: QuestionFactoryProtocol?
    private var statisticService: StatisticServiceProtocol!
    private var currentQuestion: QuizQuestions?
    weak var recordsController: RecordsViewController?
    
    private var questionsIndex: Int = 0
    private let questionAmount: Int = 10
    private var correctAnswers: Int = 0
    
    // MARK: -Init
    init(viewController: MovieQuizViewController) {
        self.viewController = viewController
        
        statisticService = StatisticService()
        questionsFactory = QuestionFactory(delegate: self, movieLoader: MovieLoader())
        questionsFactory?.loadData()
    }
    
    init(recordsController: RecordsViewController) {
        self.recordsController = recordsController
        
        statisticService = StatisticService()
    }
    
    //MARK: - Methods
    func getResultMessage() -> String {
        let text = """
Ваш результат: \(correctAnswers)/\(questionAmount)
Колличество сыгранных игр: \(statisticService.gameCount)
Рекорд: \(statisticService.bestGame.correct)/10 (\(statisticService.bestGame.date.dateTimeString))
Средняя точность: \(String(format: "%.2f", statisticService.totalAccuracy))%
"""
        return text
    }
    
    func setLabelData() -> String {
        let text = """
Колличество сыгранных игр: \(statisticService.gameCount)
Рекорд: \(statisticService.bestGame.correct)/10 (\(statisticService.bestGame.date.dateTimeString))
Средняя точность: \(String(format: "%.2f", statisticService.totalAccuracy))%
"""
        return text
    }
    
    func restartGame() {
        questionsFactory?.requestNextQuestions()
        questionsIndex = 0
        correctAnswers = 0
    }
    
    func noButtonClicked() {
        didAnswer(yesOrNo: false)
    }
    
    func yesButtonClicked() {
        didAnswer(yesOrNo: true)
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
    
    private func checkAnswer(isCorrect: Bool) {
        if isCorrect {
            correctAnswers += 1
        }
    }
    
    private func showAnswerResult(isCorrect: Bool) {
        checkAnswer(isCorrect: isCorrect)
        viewController?.highlightImageBorder(isCorrect: isCorrect)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self else { return }

            self.showNextQuestionsOrResult()
        }
    }
    
    private func didAnswer(yesOrNo: Bool) {
        guard let currentQuestion else { return }
        let givenAnswer = yesOrNo
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    
    private func convert(model: QuizQuestions) -> QuizStepViewModel {
        QuizStepViewModel(image: UIImage(data: model.image) ?? UIImage(),
                          questions: model.text,
                          questionNumber: String(questionsIndex + 1) + "/10")
    }
    
    private func showNextQuestionsOrResult() {
        if isLastQuestion() {
            statisticService.store(correct: self.correctAnswers, total: self.questionAmount)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
                guard let self else { return }
                self.viewController?.getAlertResult()
                viewController?.enabledButtons(isEnabled: true)
            }
        } else {
            self.switchToNextQuestion()
            questionsFactory?.requestNextQuestions()
            viewController?.enabledButtons(isEnabled: true)
            }
        }
    
    private func isLastQuestion() -> Bool {
        questionsIndex == (questionAmount - 1)
    }
    
    private func switchToNextQuestion() {
        questionsIndex += 1
    }
}

extension MovieQuizPresenter: QuestionFactoryDelegate {
    func didLoadDataFromServer() {
        viewController?.hideIndicator()
        questionsFactory?.requestNextQuestions()
    }
    
    func didFailToLoadData(with error: Error) {
        viewController?.showNetworkError(message: error.localizedDescription)
    }
    
    
}

// MARK: - Import library
import UIKit
import Foundation

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate {

// MARK: - Outlets
    
    @IBOutlet private weak var movieImage: UIImageView!
    @IBOutlet private weak var movieQuestions: UILabel!
    @IBOutlet private weak var movieCount: UILabel!
    @IBOutlet weak var yesButton: UIButton!
    @IBOutlet weak var noButton: UIButton!
    
// MARK: - Actions
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        enabledButtons(isEnabled: false)
        guard let question = currentQuestion else { return }
        if question.correctAnswer == false {
            rightAnswers += 1
            showAnswerResult(isCorrect: true)
        } else {
            showAnswerResult(isCorrect: false)
        }
    }
    
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        enabledButtons(isEnabled: false)
        guard let question = currentQuestion else { return }
        if question.correctAnswer == true {
            rightAnswers += 1
            showAnswerResult(isCorrect: true)
        } else {
            showAnswerResult(isCorrect: false)
        }
    }
    
// MARK: - Variables
    
    private var questionsIndex: Int = 0
    private var rightAnswers: Int = 0
    private let questionAmount: Int = 10
    private var questionsFactory: QuestionFactoryProtocol?
    private var currentQuestion: QuizQuestions?
    private var alertPresenter: AlertPresenterProtocol?
    
    private var statisticService: StatisticServiceProtocol!
    
// MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        questionsFactory = QuestionFactory(delegate: self)
        alertPresenter = AlertPresenter(delegate: self)
        statisticService = StatisticService()
        
        questionsFactory?.requestNextQuestions()
    }
// MARK: - Methods
    
    func didReceiveNextQuestion(question: QuizQuestions?) {
        guard let question = question else { return }

        currentQuestion = question
        let viewModel = convert(model: question)
        DispatchQueue.main.async { [weak self] in
            self?.show(quiz: viewModel)
        }
    }
    
    private func show(quiz step: QuizStepViewModel) {
        movieImage.image = step.image
        movieQuestions.text = step.questions
        movieCount.text = step.questionNumber
    }
    
    private func enabledButtons(isEnabled: Bool) {
        noButton.isEnabled = isEnabled
        yesButton.isEnabled = isEnabled
    }
    
    private func convert(model: QuizQuestions) -> QuizStepViewModel {
        QuizStepViewModel(image: UIImage(named: model.image) ?? UIImage(),
                          questions: model.text,
                          questionNumber: String(questionsIndex + 1) + "/10")
    }
    
    private func showAnswerResult(isCorrect: Bool) {
        movieImage.layer.masksToBounds = true
        movieImage.layer.borderWidth = 8
        movieImage.layer.cornerRadius = 12
        movieImage.layer.borderColor = UIColor(named: isCorrect ? "ypGreen" : "ypRed")?.cgColor
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self else { return }
            
            movieImage.layer.borderWidth = 0
            questionsIndex += 1
            showNextQuestionsOrResult()
        }
    }
    
    private func showNextQuestionsOrResult() {
        
        if questionsIndex <= questionAmount - 1 {
            questionsFactory?.requestNextQuestions()
            enabledButtons(isEnabled: true)
        } else {
            statisticService.store(correct: rightAnswers, total: questionAmount)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.getAlertResult()
            }
        }
    }
}

// MARK: - Extension

extension MovieQuizViewController: AlertPresenterDelegate {
    
    func getAlertResult() {
        
        let text = """

Ваш результат: \(rightAnswers)/10
Колличество сыгранных игр: \(statisticService.gameCount)
Рекорд: \(statisticService.bestGame.correct)/10 (\(statisticService.bestGame.date.dateTimeString))
Средняя точность: \(String(format: "%.2f", statisticService.totalAccuracy))%
"""
        let alertModel: AlertModel = AlertModel(title: "Этот раунд окончен!",
                                                message: text,
                                                buttonText: "Сыграть ещё раз!") {
            self.questionsIndex = 0
            self.rightAnswers = 0
            self.showNextQuestionsOrResult()
        }
        alertPresenter?.showResult(model: alertModel)
    }
}

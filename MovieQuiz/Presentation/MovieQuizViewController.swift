// MARK: - Import library
import UIKit
import Foundation

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate {

// MARK: - Outlets
    
    @IBOutlet private var activityIndicator: UIActivityIndicatorView!
    @IBOutlet private weak var movieImage: UIImageView!
    @IBOutlet private weak var movieQuestions: UILabel!
    @IBOutlet private weak var movieCount: UILabel!
    @IBOutlet weak var yesButton: UIButton!
    @IBOutlet weak var noButton: UIButton!
    
// MARK: - Actions
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        enabledButtons(isEnabled: false)
        presenter.currentQuestion = currentQuestion
        presenter.noButtonClicked()
    }
    
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        enabledButtons(isEnabled: false)
        presenter.currentQuestion = currentQuestion
        presenter.yesButtonClicked()
    }
    
// MARK: - Variables
    
    private var questionsIndex: Int = 0
    
    private var presenter = MovieQuizPresenter()
    private var questionsFactory: QuestionFactoryProtocol?
    private var currentQuestion: QuizQuestions?
    private var alertPresenter: AlertPresenterProtocol?
    
    private var statisticService: StatisticServiceProtocol!
    
// MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        questionsFactory = QuestionFactory(delegate: self, movieLoader: MovieLoader())
        alertPresenter = AlertPresenter(delegate: self)
        statisticService = StatisticService()
        presenter.viewController = self
        
        showIndicator()
        questionsFactory?.loadData()
    }
    
// MARK: - Methods
    
    func didReceiveNextQuestion(question: QuizQuestions?) {
        guard let question = question else { return }

        currentQuestion = question
        let viewModel = presenter.convert(model: question)
        DispatchQueue.main.async { [weak self] in
            self?.show(quiz: viewModel)
        }
    }
    
    func didLoadDataFromServer() {
        activityIndicator.isHidden = true
        questionsFactory?.requestNextQuestions()
    }
    
    func didFailToLoadData(with error: Error) {
        showNetworkError(message: error.localizedDescription)
    }
    
    private func restartGame() {
        presenter.resetQuestionIndex()
        questionsFactory?.requestNextQuestions()
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
    
    
    
    func showAnswerResult(isCorrect: Bool) {
        movieImage.layer.masksToBounds = true
        movieImage.layer.borderWidth = 8
        movieImage.layer.cornerRadius = 12
        movieImage.layer.borderColor = UIColor(named: isCorrect ? "ypGreen" : "ypRed")?.cgColor
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self else { return }
            
            movieImage.layer.borderWidth = 0
            showNextQuestionsOrResult()
        }
    }
    
    private func showNetworkError(message: String) {
        hideIndicator()
        presenter.resetQuestionIndex()
        let alert = AlertModel(title: "Ошибка!",
                               message: message,
                               buttonText: "Попробовать еще раз!") { [weak self] in
            guard let self else { return }
            self.questionsFactory?.requestNextQuestions()
        }
        alertPresenter?.showResult(model: alert)
    }
    
    private func showIndicator() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
    private func hideIndicator() {
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
    }
    
    private func showNextQuestionsOrResult() {
        if presenter.isLastQuestion() {
            statisticService.store(correct: presenter.correctAnswers, total: presenter.questionAmount)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.getAlertResult()
            }
        } else {
            presenter.switchToNextQuestion()
            questionsFactory?.requestNextQuestions()
            enabledButtons(isEnabled: true)
            }
        }
    }

// MARK: - Extension

extension MovieQuizViewController: AlertPresenterDelegate {
    
    func getAlertResult() {
        
        let text = """
Ваш результат: \(presenter.correctAnswers)/\(presenter.questionAmount)
Колличество сыгранных игр: \(statisticService.gameCount)
Рекорд: \(statisticService.bestGame.correct)/10 (\(statisticService.bestGame.date.dateTimeString))
Средняя точность: \(String(format: "%.2f", statisticService.totalAccuracy))%
"""
        let alertModel: AlertModel = AlertModel(title: "Этот раунд окончен!",
                                                message: text,
                                                buttonText: "Сыграть ещё раз!") {
            self.presenter.resetQuestionIndex()
            self.showNextQuestionsOrResult()
        }
        alertPresenter?.showResult(model: alertModel)
    }
}

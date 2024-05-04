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
        presenter.noButtonClicked()
    }
    
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        enabledButtons(isEnabled: false)
        presenter.yesButtonClicked()
    }
    
// MARK: - Variables
    private var presenter = MovieQuizPresenter()
    var questionsFactory: QuestionFactoryProtocol?
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
    
    func show(quiz step: QuizStepViewModel) {
        movieImage.image = step.image
        movieQuestions.text = step.questions
        movieCount.text = step.questionNumber
    }
    
    func enabledButtons(isEnabled: Bool) {
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
            
            self.presenter.statisticService = self.statisticService
            self.presenter.questionsFactory = self.questionsFactory
            self.presenter.showNextQuestionsOrResult()
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
    func didReceiveNextQuestion(question: QuizQuestions?) {
    }
}

// MARK: - Extensios
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
            self.presenter.showNextQuestionsOrResult()
        }
        alertPresenter?.showResult(model: alertModel)
    }
}

// MARK: - Import library
import UIKit

final class MovieQuizViewController: UIViewController {

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
    private var presenter: MovieQuizPresenter!
    private var alertPresenter: AlertPresenterProtocol?
    
// MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        alertPresenter = AlertPresenter(delegate: self)
        presenter = MovieQuizPresenter(viewController: self)
        
        showIndicator()
    }
    
// MARK: - Methods
    func show(quiz step: QuizStepViewModel) {
        movieImage.layer.borderWidth = 0
        movieImage.image = step.image
        movieQuestions.text = step.questions
        movieCount.text = step.questionNumber
    }
    
    func enabledButtons(isEnabled: Bool) {
        noButton.isEnabled = isEnabled
        yesButton.isEnabled = isEnabled
    }
    
    func highlightImageBorder(isCorrect: Bool) {
        movieImage.layer.masksToBounds = true
        movieImage.layer.borderWidth = 8
        movieImage.layer.cornerRadius = 12
        movieImage.layer.borderColor = UIColor(named: isCorrect ? "ypGreen" : "ypRed")?.cgColor
    }
    
    func showNetworkError(message: String) {
        hideIndicator()
        let alert = AlertModel(title: "Ошибка!",
                               message: message,
                               buttonText: "Попробовать еще раз!") { [weak self] in
            guard let self else { return }
            self.presenter.restartGame()
        }
        alertPresenter?.showResult(model: alert)
    }
    
    func showIndicator() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
    func hideIndicator() {
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
    }
}

// MARK: - Extensios
extension MovieQuizViewController: AlertPresenterDelegate {
    
    func getAlertResult() {
        
        let text = presenter.getResultMessage()
        let alertModel: AlertModel = AlertModel(title: "Этот раунд окончен!",
                                                message: text,
                                                buttonText: "Сыграть ещё раз!") {
            self.presenter.restartGame()
        }
        alertPresenter?.showResult(model: alertModel)
    }
}

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
        currentQuestion = questionsFactory.requestNextQuestions()
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
        currentQuestion = questionsFactory.requestNextQuestions()
    }
    
    // MARK: - Variables
    
    private var questionsIndex: Int = 0
    private var rightAnswers: Int = 0
    
    private let questionAmount: Int = 10
    private var questionsFactory: QuestionFactoryProtocol = QuestionFactory()
    private var currentQuestion: QuizQuestions?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currentQuestion = questionsFactory.requestNextQuestions()
        showNextQuestionsOrResult()
        
    }
    // MARK: - Methods
    
    func didReceiveNextQuestion(question: QuizQuestions?) {
        <#code#>
    }
    
    private func show(quiz step: QuizStepViewModel) {
        
        movieImage.image = step.image
        movieQuestions.text = step.questions
        movieCount.text = step.questionNumber
        
    }
    
    private func enabledButtons(isEnabled: Bool) {
        self.noButton.isEnabled = isEnabled
        self.yesButton.isEnabled = isEnabled
    }
    
    private func show(quizResult result: QuizResultViewModel) {
        
        let alert = UIAlertController(title: result.title, message: result.text, preferredStyle: .alert)
        
        let action = UIAlertAction(title: result.buttonText, style: .default) { [weak self] _ in
            guard let self else { return }
            
            self.questionsIndex = 0
            self.rightAnswers = 0
            self.showNextQuestionsOrResult()
        }
        alert.addAction(action)
        present(alert, animated: true)
    }
    
    private func convert(model: QuizQuestions) -> QuizStepViewModel {
        QuizStepViewModel(image: UIImage(named: model.image) ?? UIImage(),
                          questions: model.text,
                          questionNumber: String(questionsIndex + 1) + "/10")
    }
    
    private func showAnswerResult(isCorrect: Bool) {
        
        self.movieImage.layer.masksToBounds = true
        self.movieImage.layer.borderWidth = 8
        self.movieImage.layer.cornerRadius = 12
        if isCorrect {
            self.movieImage.layer.borderColor = UIColor(named: "ypGreen")?.cgColor
        } else {
            self.movieImage.layer.borderColor = UIColor(named: "ypRed")?.cgColor
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self else { return }
            
            self.movieImage.layer.borderWidth = 0
            self.showNextQuestionsOrResult()
        }
        
    }
    
    private func showNextQuestionsOrResult() {
        
        enabledButtons(isEnabled: true)
        if questionsIndex <= 9 {
            guard let question = currentQuestion else { return }
            let quiz = convert(model: question)
            show(quiz: quiz)
            questionsIndex += 1
            
        } else {
            
            let resultModel = QuizResultViewModel(title: "Игра окончена!", text: "Вы набрали -  \(rightAnswers)", buttonText: "Начать снова!")
            
            show(quizResult: resultModel)
        }
    }
}

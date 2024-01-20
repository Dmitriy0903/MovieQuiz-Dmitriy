// MARK: - Import library
import UIKit
import Foundation

final class MovieQuizViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet private weak var movieImage: UIImageView!
    @IBOutlet private weak var movieQuestions: UILabel!
    @IBOutlet private weak var movieCount: UILabel!
    @IBOutlet weak var yesButton: UIButton!
    @IBOutlet weak var noButton: UIButton!
    
    // MARK: - Actions
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        if questions[questionsIndex].correctAnswer == false {
            rightAnswers += 1
            showAnswerResult(isCorrect: true)
        } else {
            showAnswerResult(isCorrect: false)
        }
        
        
        showNextQuestionsOrResult()
        
        
    }
    
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        if questions[questionsIndex].correctAnswer == true {
            rightAnswers += 1
            showAnswerResult(isCorrect: true)
        } else {
            showAnswerResult(isCorrect: false)
        }
        
        
        showNextQuestionsOrResult()
    }
    
    
    
    // MARK: - Variables
    
    var questionsIndex: Int = 0
    var rightAnswers: Int = 0
    
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showNextQuestionsOrResult()
        
        
    }
    // MARK: - Methods
    private func show(quiz step: QuizStepViewModel) {
        movieImage.image = step.image
        movieQuestions.text = step.questions
        movieCount.text = step.questionNumber
    }
    
    private func show(quizResult result: QuizResultViewModel) {
        
        let alert = UIAlertController(title: result.text, message: result.text, preferredStyle: .alert)
        
        let action = UIAlertAction(title: result.buttonText, style: .default) { _ in
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
    }
    
    private func showNextQuestionsOrResult() {
        
        
        if questionsIndex < 9 {
            
            let quiz = convert(model: questions[questionsIndex])
            show(quiz: quiz)
            questionsIndex += 1
            
            
        } else {
            
            let resultModel = QuizResultViewModel(title: "ИГРА ОКОНЧЕНА", text: "Вы набрали \(rightAnswers)", buttonText: "Начать снова!")
            
            show(quizResult: resultModel)
        }
        
    }
}

// MARK: - Models


struct QuizQuestions {
    let image: String
    let text: String
    let correctAnswer: Bool
}

struct QuizStepViewModel {
    let image: UIImage
    let questions: String
    let questionNumber: String
}

struct QuizResultViewModel {
    let title: String
    let text: String
    let buttonText: String
}


 // MARK: - Mock-данные
 
private let questions: [QuizQuestions] = [
    QuizQuestions(image: "The Godfather",
                  text: "Рейтинг этого фильма больше чем 6?",
                  correctAnswer: true),
    QuizQuestions(image: "The Dark Knight",
                  text: "Рейтинг этого фильма больше чем 6?",
                  correctAnswer: true),
    QuizQuestions(image: "Kill Bill",
                  text: "Вопрос: Рейтинг этого фильма больше чем 6?",
                  correctAnswer: true),
    QuizQuestions(image: "The Avengers",
                  text: "Рейтинг этого фильма больше чем 6?",
                  correctAnswer: true),
    QuizQuestions(image: "Deadpool",
                  text: "Рейтинг этого фильма больше чем 6?",
                  correctAnswer: true),
    QuizQuestions(image: "The Green Knight",
                  text: "Рейтинг этого фильма больше чем 6?",
                  correctAnswer: true),
    QuizQuestions(image: "Old",
                  text: "Рейтинг этого фильма больше чем 6?",
                  correctAnswer: false),
    QuizQuestions(image: "The Ice Age Adventures of Buck Wild",
                  text: "Рейтинг этого фильма больше чем 6?",
                  correctAnswer: false),
    QuizQuestions(image: "Tesla",
                  text: "Рейтинг этого фильма больше чем 6?",
                  correctAnswer: false),
    QuizQuestions(image: "Vivarium",
                  text: "Рейтинг этого фильма больше чем 6?",
                  correctAnswer: false)
]
 

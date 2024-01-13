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
        }
        
    }
    
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        if questions[questionsIndex].correctAnswer == true {
            rightAnswers += 1
        }
    }
    
    // MARK: - Variables
    
    var questionsIndex: Int = 0
    var rightAnswers: Int = 0
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    // MARK: - Functions
    
    private func convert(model: QuizQuestions) -> QuizStepViewModel {
        QuizStepViewModel(image: UIImage(named: model.image) ?? UIImage(),
                          questions: model.text,
                          questionNumber: String(questionsIndex + 1) + "/10")
            
        }
    private func showAnswerResult(isCorrect: Bool) {
        movieImage.layer.masksToBounds = true
        movieImage.layer.borderWidth = 1
        movieImage.layer.cornerRadius = 6
        if isCorrect {
            movieImage.layer.borderColor = UIColor(named: "ypGreen")?.cgColor
        } else {
            movieImage.layer.borderColor = UIColor(named: "ypRed")?.cgColor
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
 

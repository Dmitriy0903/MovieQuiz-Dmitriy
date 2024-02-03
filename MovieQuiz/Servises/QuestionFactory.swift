//
//  QuestionFactory.swift
//  MovieQuiz
//
//  Created by movavi_school on 03.02.2024.
//

import Foundation


class QuestionFactory: QuestionFactoryProtocol {
    
    weak var delegate: QuestionFactoryDelegate?
    
    func requestNextQuestions() {
        guard let randomNum = (0..<questions.count).randomElement() else {
            delegate?.didReceiveNextQuestion(question: nil)
            return
        }
        let question = questions[safe: randomNum]
        delegate?.didReceiveNextQuestion(question: question)
    }
    
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
                      correctAnswer: false)]
}

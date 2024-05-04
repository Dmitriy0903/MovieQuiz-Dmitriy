//
//  QuestionFactory.swift
//  MovieQuiz
//
//  Created by movavi_school on 03.02.2024.
//

import Foundation

class QuestionFactory: QuestionFactoryProtocol {
    
    private weak var delegate: QuestionFactoryDelegate?
    private var movieLoader: MovieLoaderProtocol
    private var movies: [MostPopularMovie] = []
    
    init(delegate: QuestionFactoryDelegate?, movieLoader: MovieLoaderProtocol) {
        self.delegate = delegate
        self.movieLoader = movieLoader
    }
    
    func requestNextQuestions() {
        DispatchQueue.global().async { [weak self] in
            guard let self else { return }
            let index = (0..<self.movies.count).randomElement() ?? 0
            guard let movie = self.movies[safe: index] else { return }
            var imageData = Data()
            
            do {
                imageData = try Data(contentsOf: movie.imageURL)
            } catch {
                print("Ошибка в загрузке картнки")
            }
            
            let rating = Float(movie.rating) ?? 0
            
            var questionRank: Float
            
            if rating <= 6.5 {
                questionRank = Float.random(in: 6.3...6.7)
            } else if rating <= 7.5 {
                questionRank = Float.random(in: 7.3...7.6)
            } else if rating <= 8.0 {
                questionRank = Float.random(in: 7.8...8.1)
            } else if rating <= 8.3 {
                questionRank = Float.random(in: 8.1...8.4)
            } else if rating <= 8.6 {
                questionRank = Float.random(in: 8.35...8.7)
            } else if rating <= 9.0 {
                questionRank = Float.random(in: 8.7...9.1)
            } else if rating <= 9.3 {
                questionRank = Float.random(in: 9.1...9.4)
            } else {
                questionRank = 9.5
            }
            
            let numForMoreOrLess: Dictionary = [1: "больше", 2: "меньше"]
            let indexForMoreOrLess = (1...2).randomElement() ?? 1
            
            let moreOrLess: String = numForMoreOrLess[indexForMoreOrLess] ?? "!"

            let text = "Рейтинг этого фильма \(moreOrLess) чем \(String(format: "%.1f", questionRank))?"
            var correctAnswer: Bool
            
            if indexForMoreOrLess == 1 {
                correctAnswer = rating > questionRank
            } else {
                correctAnswer = rating < questionRank
            }
            
            let question = QuizQuestions(image: imageData,
                                         text: text,
                                         correctAnswer: correctAnswer)
            
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                delegate?.didReceiveNextQuestion(question: question)
                return
            }
                
            }
        }
        
    func loadData() {
        movieLoader.loadMoview { [weak self] result in
            DispatchQueue.main.async {
                guard let self else { return }
                switch result {
                case .success(let mostPopularMovies):
                    self.movies = mostPopularMovies.items
                    self.delegate?.didLoadDataFromServer()
                case .failure(let error):
                    self.delegate?.didFailToLoadData(with: error)
                }
            }
        
        }
    }
    }
    
//    private let questions: [QuizQuestions] = [
//        QuizQuestions(image: "The Godfather",
//                      text: "Рейтинг этого фильма больше чем 6?",
//                      correctAnswer: true),
//        QuizQuestions(image: "The Dark Knight",
//                      text: "Рейтинг этого фильма больше чем 6?",
//                      correctAnswer: true),
//        QuizQuestions(image: "Kill Bill",
//                      text: "Вопрос: Рейтинг этого фильма больше чем 6?",
//                      correctAnswer: true),
//        QuizQuestions(image: "The Avengers",
//                      text: "Рейтинг этого фильма больше чем 6?",
//                      correctAnswer: true),
//        QuizQuestions(image: "Deadpool",
//                      text: "Рейтинг этого фильма больше чем 6?",
//                      correctAnswer: true),
//        QuizQuestions(image: "The Green Knight",
//                      text: "Рейтинг этого фильма больше чем 6?",
//                      correctAnswer: true),
//        QuizQuestions(image: "Old",
//                      text: "Рейтинг этого фильма больше чем 6?",
//                      correctAnswer: false),
//        QuizQuestions(image: "The Ice Age Adventures of Buck Wild",
//                      text: "Рейтинг этого фильма больше чем 6?",
//                      correctAnswer: false),
//        QuizQuestions(image: "Tesla",
//                      text: "Рейтинг этого фильма больше чем 6?",
//                      correctAnswer: false),
//        QuizQuestions(image: "Vivarium",
//                      text: "Рейтинг этого фильма больше чем 6?",
//                      correctAnswer: false)]


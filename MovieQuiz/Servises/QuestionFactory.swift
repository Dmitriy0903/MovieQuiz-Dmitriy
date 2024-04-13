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
            
            let questionRank = (8...9).randomElement() ?? 9
            
            
            
            let text = "Рейтинг этого фильма больше чем \(questionRank)?"
            
            let correctAnswer = Int(rating) > questionRank
            print("\(rating) \(questionRank)")
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


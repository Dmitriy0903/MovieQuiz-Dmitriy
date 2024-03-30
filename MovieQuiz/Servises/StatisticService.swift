//
//  StatisticService.swift
//  MovieQuiz
//
//  Created by movavi_school on 16.03.2024.
//

import Foundation

class StatisticService: StatisticServiceProtocol {
    
    // MARK: Keys
    private enum Keys: String {
        case allTimeQuestions, bestGame, gamesCount, allTimeCorrect
    }
    
    
    // MARK: - Constants
    private let userDefaults = UserDefaults.standard
    
    
    // MARK: - Variables
    var totalAccuracy: Double {
        Double(userDefaults.integer(forKey: Keys.allTimeCorrect.rawValue)) / Double(userDefaults.integer(forKey: Keys.allTimeQuestions.rawValue)) * 100
    }
    
    var bestGame: GameRecord {
        get {
            guard let data = userDefaults.data(forKey: Keys.bestGame.rawValue),
                  let record = try? JSONDecoder().decode(GameRecord.self, from: data) else {
                print("Значение получено некорректно bestGame")
                return .init(correct: 1, total: 0, date: Date())
                  }
            return record
        }
        
        set {
            guard let data = try? JSONEncoder().encode(newValue) else {
                print("Не удалось сохранить запись")
                return
            }
            userDefaults.set(data, forKey: Keys.bestGame.rawValue)
            
        }
    }
    
    var gameCount: Int {
        get {
            guard let data = userDefaults.data(forKey: Keys.gamesCount.rawValue),
                  let count = try? JSONDecoder().decode(Int.self, from: data) else {
                    print("Значение получено некорректно gameCount")
                    return 1
                  }
            return count
        }
        
        set {
            guard let data = try? JSONEncoder().encode(newValue) else {
                print("Не удалось сохранить запись")
                return
            }
            userDefaults.set(data, forKey: Keys.gamesCount.rawValue)
        }
    }
    
    // MARK: Function
    func store(correct count: Int, total amount: Int) {
        gameCount += 1
        let currentGame = GameRecord(correct: count, total: amount, date: Date())
        
        userDefaults.set(userDefaults.integer(forKey: "allTimeCorrect") + count, forKey: "allTimeCorrect")
        userDefaults.set(userDefaults.integer(forKey: "allTimeQuestions") + amount, forKey: "allTimeQuestions")
        
        if currentGame > bestGame {
            bestGame = currentGame
        }
    }
}

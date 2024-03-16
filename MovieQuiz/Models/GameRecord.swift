//
//  GameRecord.swift
//  MovieQuiz
//
//  Created by movavi_school on 16.03.2024.
//

import Foundation

struct GameRecord: Codable {
    var correct: Int
    let total: Int
    let date: Date
    
    func update(newRecord: GameRecord) -> Bool {
        self.correct > newRecord.correct
    }
}

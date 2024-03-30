//
//  GameRecord + Extension.swift
//  MovieQuiz
//
//  Created by movavi_school on 16.03.2024.
//

import Foundation

extension GameRecord: Comparable {
    static func == (first: GameRecord, second: GameRecord) -> Bool {
        return first.correct == second.correct
    }
    
    static func < (first: GameRecord, second: GameRecord) -> Bool {
        return first.correct < second.correct
    }
}

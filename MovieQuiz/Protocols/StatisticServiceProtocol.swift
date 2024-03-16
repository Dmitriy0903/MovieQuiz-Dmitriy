//
//  StatisticServiceProtocol.swift
//  MovieQuiz
//
//  Created by movavi_school on 16.03.2024.
//

import Foundation

protocol StatisticServiceProtocol: AnyObject {
    func store(correct count: Int, total amount: Int)
    var totalAccuracy: Double { get }
    var bestGame: GameRecord { get }
    var gameCount: Int { get }
}

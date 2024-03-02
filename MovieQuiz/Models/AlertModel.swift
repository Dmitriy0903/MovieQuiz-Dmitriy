//
//  AlertModel.swift
//  MovieQuiz
//
//  Created by movavi_school on 17.02.2024.
//

import Foundation

struct AlertModel {
    let title: String?
    let message: String?
    let buttonText: String?
    let completion: () -> ()?
}

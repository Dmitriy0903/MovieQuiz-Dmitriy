//
//  AlertModel.swift
//  MovieQuiz
//
//  Created by movavi_school on 17.02.2024.
//

import Foundation

struct AlertModel {
    let title: String = "Игра окончена!"
    let message: String = "Вы набрали - "
    let buttonText: String = "Начать снова?"
    let completion: () -> ()
}

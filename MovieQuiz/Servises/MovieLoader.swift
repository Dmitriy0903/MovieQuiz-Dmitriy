//
//  MovieLoader.swift
//  MovieQuiz
//
//  Created by movavi_school on 30.03.2024.
//

import Foundation

struct movieLoader {
    // MARK: - URL
    private var movieURL: URL {
        guard let url = URL(string: "https://tv-api.com/en/API/Top250Movies/k_zcuw1ytf") else {
            preconditionFailure("Невозможно достать значение по ссылке!")
        }
        return url
    }
}

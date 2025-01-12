//
//  MostPopularMovies.swift
//  MovieQuiz
//
//  Created by movavi_school on 06.04.2024.
//

import Foundation

struct MostPopularMovies: Codable {
    let errorMessage: String
    let items: [MostPopularMovie]
}

struct MostPopularMovie: Codable {
    let year: String
    let id: String
    let title: String
    let rating: String
    let imageURL: URL
    
    private enum CodingKeys: String, CodingKey {
        case year = "year"
        case id = "id"
        case title = "fullTitle"
        case rating = "imDbRating"
        case imageURL = "image"
    }
}

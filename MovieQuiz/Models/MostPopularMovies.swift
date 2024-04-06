//
//  MostPopularMovies.swift
//  MovieQuiz
//
//  Created by movavi_school on 06.04.2024.
//

import Foundation

struct MostPopularMovies: Codable {
    let errorMessage: String
    let movies: [MostPopularMovie]
}

struct MostPopularMovie: Codable {
    let title: String
    let rating: String
    let imageURL: URL
    
    private enum CodingKeys: String, CodingKey {
        case title = "fullTitle"
        case rating = "rank"
        case imageURL = "image"
    }
}

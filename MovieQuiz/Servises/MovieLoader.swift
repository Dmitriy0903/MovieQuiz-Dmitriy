//
//  MovieLoader.swift
//  MovieQuiz
//
//  Created by movavi_school on 30.03.2024.
//

import Foundation

protocol MovieLoaderProtocol {
    func loadMoview(handler: @escaping (Result<MostPopularMovies, Error>) -> Void)
}

struct movieLoader: MovieLoaderProtocol {
    
    private let networkClient = NetworkClient()
    
    // MARK: - URL
    private var movieURL: URL {
        guard let url = URL(string: "https://tv-api.com/en/API/Top250Movies/k_zcuw1ytf") else {
            preconditionFailure("Невозможно достать значение по ссылке!")
        }
        return url
    }
    
    func loadMoview(handler: @escaping (Result<MostPopularMovies, Error>) -> Void) {
        networkClient.fetch(url: movieURL) { result in
            switch result {
            case .failure(let error):
                handler(.failure(error))
            case .success(let data):
                guard let decodedMovies = try?
                        JSONDecoder().decode(MostPopularMovies.self, from: data) else {
                    handler(.failure(LoaderErrors.jsonError))
                    return
                }
                
                if decodedMovies.errorMessage.isEmpty {
                    handler(.success(decodedMovies))
                } else {
                    handler(.failure(LoaderErrors.errorMessageFromData))
                }
            }
        }
    }
    
    private enum LoaderErrors: Error {
        case jsonError
        case errorMessageFromData
    }
}

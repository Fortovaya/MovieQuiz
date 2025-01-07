//
//  MoviesLoadingProtocol.swift
//  MovieQuiz
//
//  Created by Алина on 03.01.2025.
//

import Foundation

protocol MoviesLoading {
    func loadMovies(handler: @escaping (Result<MostPopularMovies, Error>) -> Void)
}

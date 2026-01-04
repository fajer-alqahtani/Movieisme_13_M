//
//  MovieService.swift
//  Movieisme_13_M
//
//  Created by Yousra Abdelrahman on 14/07/1447 AH.
//
import Foundation

struct MovieService {
    func fetchMovies() async throws -> [MovieModel] {
        let response = try await NetworkService.shared.request(
            endpoint: .movies,
            responseType: MovieResponseModel.self
        )
        return response.records.map { $0.fields }
    }
}


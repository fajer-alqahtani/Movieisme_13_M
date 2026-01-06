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
        response.records.forEach { record in
                    print("🆔 Backend ID:", record.id)
                }
        let movies = response.records.map { record in
            MovieModel(
                id: record.id,
                name: record.fields.name,
                poster: record.fields.poster,
                story: record.fields.story,
                runtime: record.fields.runtime,
                genre: record.fields.genre,
                rating: record.fields.rating,
                imdbRating: record.fields.imdbRating,
                language: record.fields.language
            )
        }

        movies.forEach { movie in
            print("🎬 MovieModel ID:", movie.id)
        }

        return movies
    }
}


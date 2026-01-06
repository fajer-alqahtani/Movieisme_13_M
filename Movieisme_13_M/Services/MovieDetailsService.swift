//
//  MovieDetailsService.swift
//  Movieisme_13_M
//
//  Created by Yousra Abdelrahman on 17/07/1447 AH.
//

import Foundation

struct MovieDetailsService {
    
    // Fetch all actors
    func fetchAllActors() async throws -> [ActorModel] {
        let response = try await NetworkService.shared.request(
            endpoint: .actors,
            responseType: ActorResponseModel.self
        )
        return response.records.map {
            ActorModel(
                id: $0.id,
                name: $0.fields.name,
                image: $0.fields.image
            )
        }
    }
    
    // Fetch movie-actor relationships for a specific movie
    func fetchMovieActors(movieId: String) async throws -> [String] {
        let response = try await NetworkService.shared.request(
            endpoint: .movieActors(movieId: movieId),
            responseType: MovieActorResponseModel.self
        )
        return response.records.map { $0.fields.actorId }
    }
    
    // Convenience: fetch filtered actors for a movie
    func fetchActors(for movieId: String) async throws -> [ActorModel] {
        async let allActors = fetchAllActors()
        async let actorIds = fetchMovieActors(movieId: movieId)
        
        let (actors, ids) = try await (allActors, actorIds)
        return actors.filter { ids.contains($0.id) }
    }
}

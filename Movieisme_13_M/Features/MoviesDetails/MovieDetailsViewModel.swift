//
//  MovieDetailsViewModel.swift
//  Movieisme_13_M
//
//  Created by Yousra Abdelrahman on 17/07/1447 AH.
//

import Foundation
import Combine

@MainActor
final class MovieDetailsViewModel: ObservableObject {
    @Published var directors: [DirectorModel] = []
    @Published var actors: [ActorModel] = []
    @Published var isLoading = false
    @Published var error: AppError?
    @Published var errorMessage: String?

    
    // Movie Detail sService
    private let service = MovieDetailsService()
    
    func fetchActors(for movie: MovieModel) async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            actors = try await service.fetchActors(for: movie.id)
            error = nil
            errorMessage = nil
            print("🎭 Filtered actors for \(movie.name):", actors.map { $0.name })
        } catch {
            let appError = AppError.map(error)
            self.error = appError
            self.errorMessage = appError.localizedDescription
            print("❌ Failed fetching actors:", error)
        }
    }

    func fetchDirectors(for movie: MovieModel) async {
        isLoading = true
        do {
            //Fetch all directors
            let response = try await NetworkService.shared.request(
                endpoint: .directors,
                responseType: DirectorResponseModel.self
            )
            
            let allDirectors: [DirectorModel] = response.records.map {
                DirectorModel(
                    id: $0.id,
                    name: $0.fields.name,
                    image: $0.fields.image
                )
            }
            
            //Fetch movie_directors join table
            let movieDirectorsResponse = try await NetworkService.shared.request(
                endpoint: .movieDirectors(movieId: movie.id),
                responseType: MovieDirectorResponseModel.self
            )
            
            let movieDirectorIds = movieDirectorsResponse.records.map { $0.fields.directorId }
            
            //Filter directors for this movie
            let filteredDirectors = allDirectors.filter { movieDirectorIds.contains($0.id) }
            directors = filteredDirectors
            
            error = nil
            errorMessage = nil
            
        } catch {
            let appError = AppError.map(error)
            self.error = appError
            self.errorMessage = appError.localizedDescription
            print("❌ Failed fetching directors:", error)
        }
        isLoading = false
    }

}

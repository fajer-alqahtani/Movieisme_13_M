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
    
    @Published var actors: [ActorModel] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let service = MovieDetailsService()  // ✅ Use the service
    
    func fetchActors(for movie: MovieModel) async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            actors = try await service.fetchActors(for: movie.id)
            print("🎭 Filtered actors for \(movie.name):", actors.map { $0.name })
        } catch {
            errorMessage = error.localizedDescription
            print("❌ Failed fetching actors:", error)
        }
    }
}

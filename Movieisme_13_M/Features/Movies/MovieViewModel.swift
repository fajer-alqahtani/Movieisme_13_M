//
//  MovieViewModel.swift
//  Movieisme_13_M
//
//  Created by Yousra Abdelrahman on 08/07/1447 AH.
//
import Combine
import Foundation
//Main Actor for ViewModels
@MainActor
//final means this class can't be subclassed
final class MovieViewModel: ObservableObject {
    @Published var movies: [MovieModel] = []
    private let movieService = MovieService()
    
    
    var dramaMovies: [MovieModel] {
        movies.filter { $0.genre.contains("Drama") }
    }
    
    var comedyMovies: [MovieModel] {
        movies.filter { $0.genre.contains("Comedy") }
    }
    
    var highRatedMovies: [MovieModel] {
        movies.filter { $0.imdbRating >= 9.0 }
    }
    
    
    func loadMovies() async {
        do {
            //Returns [MovieModel]
            movies = try await movieService.fetchMovies()
            print("✅ Movies loaded:", movies.count)
        } catch {
            print("❌ Failed:", error)
        }
    }
    
    func filteredMovies(searchText: String) -> [MovieModel] {
        guard !searchText.isEmpty else { return movies }
        
        return movies.filter { movie in
            // check name
            movie.name.localizedCaseInsensitiveContains(searchText)
            // or genre
            || movie.genre.contains(where: { $0.localizedCaseInsensitiveContains(searchText) })
            // or language
            || movie.language.contains(where: { $0.localizedCaseInsensitiveContains(searchText) })
            // or IMDb rating
            || String(movie.imdbRating).contains(searchText)
        }
    }
}


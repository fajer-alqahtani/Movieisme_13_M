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
    func loadMovies() async {
            do {
                //Returns [MovieModel]
                movies = try await fetchMovies()
                print("✅ Movies loaded:", movies.count)
            } catch {
                print("❌ Failed:", error)
            }
    }
}

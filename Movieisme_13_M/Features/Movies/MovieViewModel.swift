//
//  MovieViewModel.swift
//  Movieisme_13_M
//
//  Created by Yousra Abdelrahman on 08/07/1447 AH.
//

import Combine
import Foundation

@MainActor
final class MoviesViewModel: ObservableObject {

    @Published var movies: [MovieModel] = []

    func fetchMovies() async {
        do {
            let url = URL(string: "YOUR_API_URL/movies")!
            let (data, _) = try await URLSession.shared.data(from: url)

            let response = try JSONDecoder().decode(MoviesResponseModel.self, from: data)
            self.movies = response.records.map { $0.fields }

        } catch {
            print("Failed to fetch movies:", error)
        }
    }
}

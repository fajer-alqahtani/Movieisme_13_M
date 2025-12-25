//
//  ReviewsService.swift
//  Movieisme_13_M
//
//  Created by Fajer alQahtani on 04/07/1447 AH.
//

import Foundation

enum ReviewsAPIError: LocalizedError {
    case invalidURL
    case invalidResponse(Int)

    var errorDescription: String? {
        switch self {
        case .invalidURL: return "Invalid URL"
        case .invalidResponse(let code): return "Request failed (\(code))"
        }
    }
}

final class ReviewsService {

    // ✅ ضعي baseURL الحقيقي
    private let baseURL = "YOUR_BASE_URL_HERE"

    // ✅ إذا لازم Authorization Bearer (حسب الكونفلونس)
    private let token: String? = nil  // "paste-token-here"

    struct CreateReviewBody: Encodable {
        let movie_id: Int
        let rating: Int
        let review: String
        // إذا احتاج user_id أضيفيه هنا
        // let user_id: Int
    }

    func createReview(movieId: Int, rating: Int, review: String) async throws {
        guard let url = URL(string: "\(baseURL)/review") else { throw ReviewsAPIError.invalidURL }

        var req = URLRequest(url: url)
        req.httpMethod = "POST"
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")

        if let token {
            req.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }

        req.httpBody = try JSONEncoder().encode(CreateReviewBody(movie_id: movieId,
                                                                 rating: rating,
                                                                 review: review))

        let (_, response) = try await URLSession.shared.data(for: req)
        guard let http = response as? HTTPURLResponse else { throw ReviewsAPIError.invalidResponse(-1) }
        guard (200...299).contains(http.statusCode) else { throw ReviewsAPIError.invalidResponse(http.statusCode) }
    }
}

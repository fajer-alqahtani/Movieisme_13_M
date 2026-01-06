//
//  ReviewsViewModel.swift
//  Movieisme_13_M
//
//  Created by Fajer alQahtani on 04/07/1447 AH.
//

import Foundation
import Combine

@MainActor
final class ReviewsViewModel: ObservableObject {

    @Published var isSubmitting = false
    @Published var errorMessage: String?

    private let service = ReviewsService()

    func addReview(movieId: String, rating: Int, review: String) async -> Bool {
        isSubmitting = true
        errorMessage = nil
        defer { isSubmitting = false }

        do {
            try await service.createReview(movieId: movieId,
                                           rating: rating,
                                           review: review)
            return true
        } catch {
            errorMessage = error.localizedDescription
            return false
        }
    }
}

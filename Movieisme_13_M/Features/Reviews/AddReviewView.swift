//
//  AddReviewView.swift
//  Movieisme_13_M
//
//  Created by Fajer alQahtani on 04/07/1447 AH.
//

import SwiftUI

struct AddReviewView: View {
    let movieId: String

    @Environment(\.dismiss) private var dismiss
    @StateObject private var vm = ReviewsViewModel()

    @State private var reviewText = ""
    @State private var rating = 0

    private var canSubmit: Bool {
        rating > 0 && !reviewText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            VStack(spacing: 0) {
                // Top bar
                HStack {
                    Button {
                        dismiss()
                    } label: {
                        HStack(spacing: 6) {
                            Image(systemName: "chevron.left")
                            Text("Back")
                        }
                        .foregroundColor(.yellow)
                        .font(.system(size: 16, weight: .semibold))
                    }

                    Spacer()

                    Text("Write a review")
                        .foregroundColor(.white)
                        .font(.system(size: 16, weight: .semibold))

                    Spacer()

                    Button {
                        Task {
                            let ok = await vm.addReview(movieId: movieId,
                                                        rating: rating,
                                                        review: reviewText)
                            if ok { dismiss() }
                        }
                    } label: {
                        Text(vm.isSubmitting ? "..." : "Add")
                            .foregroundColor(canSubmit ? .yellow : .gray)
                            .font(.system(size: 16, weight: .semibold))
                    }
                    .disabled(!canSubmit || vm.isSubmitting)
                }
                .padding(.horizontal, 16)
                .padding(.top, 14)
                .padding(.bottom, 10)

                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {

                        Text("Review")
                            .foregroundColor(.white)
                            .font(.system(size: 15, weight: .semibold))
                            .padding(.top, 10)

                        ZStack(alignment: .topLeading) {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color(white: 0.18))
                                .frame(height: 160)

                            TextEditor(text: $reviewText)
                                .scrollContentBackground(.hidden)
                                .foregroundColor(.white)
                                .padding(10)
                                .frame(height: 160)
                                .background(Color.clear)

                            if reviewText.isEmpty {
                                Text("Enter your review")
                                    .foregroundColor(.gray)
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 14)
                            }
                        }

                        HStack {
                            Text("Rating")
                                .foregroundColor(.white)
                                .font(.system(size: 15, weight: .semibold))

                            Spacer()

                            StarRatingView(rating: $rating)
                        }

                        if let error = vm.errorMessage {
                            Text(error)
                                .foregroundColor(.red)
                                .font(.footnote)
                        }

                        Spacer(minLength: 40)
                    }
                    .padding(.horizontal, 16)
                }
            }
        }
    }
}
#Preview {
    AddReviewView(movieId: "1")
}


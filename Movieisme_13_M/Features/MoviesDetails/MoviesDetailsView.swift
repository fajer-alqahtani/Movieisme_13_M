//
//  MoviesDetailsView.swift
//  Movieisme_13_M
//
//  Created by Yousra Abdelrahman on 04/07/1447 AH.
//

import SwiftUI

struct MovieDetailsView: View {

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {

                // MARK: - Header Image
                ZStack(alignment: .bottomLeading) {
                    Image("shawshank") // Replace later with async image
                        .resizable()
                        .scaledToFill()
                        .frame(height: 320)
                        .clipped()

                    LinearGradient(
                        gradient: Gradient(colors: [.clear, .black.opacity(0.9)]),
                        startPoint: .top,
                        endPoint: .bottom
                    )

                    Text("Shawshank")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding()
                }

                // MARK: - Movie Meta Info
                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        InfoItem(title: "Duration", value: "2 hours 22 mins")
                        Spacer()
                        InfoItem(title: "Language", value: "English")
                    }

                    HStack {
                        InfoItem(title: "Genre", value: "Drama")
                        Spacer()
                        InfoItem(title: "Age", value: "+15")
                    }
                }
                .padding(.horizontal)

                // MARK: - Story
                SectionView(title: "Story") {
                    Text(
                        "In 1947, Andy Dufresne (Tim Robbins), a banker from Maine, is convicted of murdering his wife and her lover, a golf pro. Since the state of Maine has no death penalty, he is given two consecutive life sentences and sent to the notoriously harsh Shawshank Prison."
                    )
                    .font(.body)
                    .foregroundColor(.secondary)
                }

                // MARK: - IMDb Rating
                SectionView(title: "IMDb Rating") {
                    Text("9.3 / 10")
                        .font(.title3)
                        .fontWeight(.semibold)
                }

                // MARK: - Director
                SectionView(title: "Director") {
                    HStack(spacing: 16) {
                        Circle()
                            .fill(Color.gray.opacity(0.3))
                            .frame(width: 56, height: 56)

                        Text("Frank Darabont")
                            .font(.headline)
                    }
                }

                // MARK: - Stars
                SectionView(title: "Stars") {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 20) {
                            StarView(name: "Tim Robbins")
                            StarView(name: "Morgan Freeman")
                            StarView(name: "Bob Gunton")
                        }
                    }
                }

                // MARK: - Rating & Reviews
                SectionView(title: "Rating & Reviews") {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("4.8")
                            .font(.largeTitle)
                            .fontWeight(.bold)

                        Text("out of 5")
                            .foregroundColor(.secondary)

                        ReviewCard(
                            author: "Afnan Abdullah",
                            review: "This is an engagingly simple, good-hearted film, with just enough darkness around the edges to give contrast and relief to its glowingly benign view of human nature."
                        )
                    }
                }
            }
            .padding(.bottom, 32)
        }
        .background(Color.black.ignoresSafeArea())
        .foregroundColor(.white)
    }
}

#Preview {
    MovieDetailsView()
}




// MARK: - Info Item
struct InfoItem: View {
    let title: String
    let value: String

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
            Text(value)
                .font(.subheadline)
                .fontWeight(.medium)
        }
    }
}

// MARK: - Section Wrapper
struct SectionView<Content: View>: View {
    let title: String
    let content: Content

    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.headline)
            content
        }
        .padding(.horizontal)
    }
}

// MARK: - Star View
struct StarView: View {
    let name: String

    var body: some View {
        VStack(spacing: 8) {
            Circle()
                .fill(Color.gray.opacity(0.3))
                .frame(width: 72, height: 72)

            Text(name)
                .font(.caption)
                .multilineTextAlignment(.center)
        }
        .frame(width: 80)
    }
}

// MARK: - Review Card
struct ReviewCard: View {
    let author: String
    let review: String

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Circle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 36, height: 36)

                Text(author)
                    .font(.subheadline)
                    .fontWeight(.semibold)
            }

            Text(review)
                .font(.footnote)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color.white.opacity(0.05))
        .cornerRadius(12)
    }
}

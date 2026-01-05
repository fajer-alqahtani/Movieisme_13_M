//
//  MoviesDetailsView.swift
//  Movieisme_13_M
//
//  Created by Yousra Abdelrahman on 04/07/1447 AH.
//


// MovieRecordID
import SwiftUI

struct MovieDetailsView: View {
    let movie: MovieModel
    
    
    @State private var showAddReview = false
    

    var body: some View {
        ScrollView{
            LazyVStack(alignment: .leading, spacing: 24) {
                HeaderImage(posterURL: movie.poster, title: movie.name)
                    .padding(.top, -60)
                
                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        InfoItem(title: "Duration", value: movie.runtime)
                        Spacer()
                        InfoItem(title: "Language", value: movie.language.joined(separator: ", "))
                    }
                    
                    HStack {
                        InfoItem(title: "Genre", value: movie.genre.joined(separator: " • "))
                        Spacer()
                        if movie.rating == "R" {
                            InfoItem(title: "Age", value: "+18")
                        } else {
                            InfoItem(title: "Age", value: "+13")
                        }
                        
                    }
                }
                .padding(.horizontal)
                
                SectionView(title: "Story") {
                    Text(movie.story)
                    .font(.system(size: 15))
                    .fontWeight(.medium)
                    .foregroundColor(.dark4)
                }
                
                SectionView(title: "IMDb Rating") {
                    Text(String(format: "%.1f", movie.imdbRating))
                        .font(.system(size: 15))
                        .fontWeight(.medium)
                        .foregroundColor(.dark4)
                }
                
                SectionView(title: "Director") {
                    VStack(spacing: 16) {
                        Circle()
                            .fill(Color.gray.opacity(0.3))
                            .frame(width: 76, height: 76)
                        
                        Text("Frank Darabont")
                            .font(.system(size: 15))
                            .fontWeight(.medium)
                            .foregroundColor(.dark4)
                    }
                }
                
                SectionView(title: "Stars") {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 16) {
                            StarView(name: "Tim Robbins")
                            StarView(name: "Morgan Freeman")
                            StarView(name: "Bob Gunton")
                        }
                    }
                }
                Divider()
                    .background(Color.dark4)

                SectionView(title: "Rating & Reviews") {
                    ReviewsSection(movieName: movie.name)
                }
                
            }
            WriteAReviewButton {
                showAddReview = true
            }
            .sheet(isPresented: $showAddReview) {
//                AddReviewView(movieId: movie.id)
            }
            .padding([.top,.bottom], 32)

        }
        .coordinateSpace(name: "scroll")
        .background(Color.black.ignoresSafeArea())
        .foregroundColor(.light1)
    }
}

#Preview {
    MovieDetailsView(
        movie: MovieModel(
            id: "preview-movie-id",
            name: "The Shawshank Redemption",
            poster: "https://m.media-amazon.com/images/M/MV5BMDFkYTc0MGEtZmRhMC00ZDIwLTgxNWEtN2IyODc5N2U3YzY3XkEyXkFqcGc@._V1_.jpg",
            story: "Two imprisoned men bond over a number of years, finding solace and eventual redemption through acts of common decency.",
            runtime: "2h 22m",
            genre: ["Drama"],
            rating: "R",
            imdbRating: 9.3,
            language: ["English"]
        )
    )
    .preferredColorScheme(.dark)
}

// MARK: - Header Image
private struct HeaderImage: View{
    let posterURL: String
    let title: String
    
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            AsyncImage(url: URL(string: posterURL)) { image in
                image
                .resizable()
                .scaledToFill()
            } placeholder: {
                Color.dark2
            }
            .frame(height: 448)

            LinearGradient(
                gradient: Gradient(colors: [.clear, .black.opacity(0.82)]),
                startPoint: .top,
                endPoint: .bottom
            )

            Text(title)
                .font(.title2)
                .fontWeight(.bold)
                .padding()
        }
        .frame(height: 448)
    }
}

// MARK: - Info Item
struct InfoItem: View {
    let title: String
    let value: String

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(.light1)
            Text(value)
                .font(.system(size: 16))
                .fontWeight(.medium)
                .foregroundColor(.dark4)
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
        VStack{
            Circle()
                .fill(Color.gray.opacity(0.3))
                .frame(width: 76, height: 76)

            Text(name)
                .font(.system(size: 15))
                .fontWeight(.medium)
                .foregroundColor(.dark4)
                .multilineTextAlignment(.center)
        }
        .frame(width:110)
    }
}

// MARK: - Review Card
struct ReviewCards: View {
    let author: String
    let review: String
    let reviewDay: String
    let rating: Int

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Circle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 38, height: 38)

                VStack(alignment: .leading) {
                    Text(author)
                        .font(.system(size: 13))
                        .fontWeight(.semibold)

                    HStack(spacing: 2) {
                        ForEach(1...5, id: \.self) { i in
                            Image(systemName: i <= rating ? "star.fill" : "star")
                                .foregroundColor(.brandMain)
                                .font(.system(size: 7.35))
                        }
                    }
                }
                Spacer()
            }

            Text(review)
                .font(.system(size: 13))
                .foregroundColor(.light1)

            HStack {
                Spacer()
                Text(reviewDay)
                    .font(.system(size: 13))
                    .foregroundColor(.dark4)
            }
        }
        .padding()
        .background(Color.dark1)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}


//MARK: - Write a Review button
struct WriteAReviewButton: View {
    let action: () -> Void

    var body: some View {
        Button {
            action()
        } label: {
            Image(systemName: "square.and.pencil")
            Text("Write a review")
        }
        .buttonStyle(.plain)
        .foregroundColor(.brandMain)
        .font(.system(size: 16))
        .fontWeight(.regular)
        .frame(width: 300, height: 50)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.brandMain, lineWidth: 1)
        )
    }
}

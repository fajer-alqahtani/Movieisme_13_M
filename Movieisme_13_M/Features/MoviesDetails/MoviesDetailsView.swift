//
//  MoviesDetailsView.swift
//  Movieisme_13_M
//
//  Created by Yousra Abdelrahman on 04/07/1447 AH.
//

import SwiftUI

struct MovieDetailsView: View {
    let movie: MovieModel
    @Environment(\.presentationMode) var presentationMode
    @State private var showAddReview = false
    @StateObject private var movieDetailsVM = MovieDetailsViewModel()
    var body: some View {
        NavigationStack{
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
                        Text(String(format: "%.1f/10", movie.imdbRating))
                            .font(.system(size: 15))
                            .fontWeight(.medium)
                            .foregroundColor(.dark4)
                    }
                    
                    SectionView(title: "Director") {
                        if movieDetailsVM.isLoading {
                                ProgressView()
                            } else {
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: 16) {
                                        ForEach(movieDetailsVM.directors) { director in
                                            StarView(
                                                name: director.name,
                                                imageURL: director.image
                                            )
                                        }
                                    }
                                }
                            }
                    }
                    
                    SectionView(title: "Stars") {
                        if movieDetailsVM.isLoading {
                            ProgressView()
                        //Safeguard: prevents SwiftUI from crashing while the async data is fetched.
                        } else if movieDetailsVM.actors.isEmpty {
                            Text("No actors available")
                                .foregroundColor(.gray)
                        } else {
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 16) {
                                    ForEach(movieDetailsVM.actors) { actor in
                                        StarView(
                                            //Safeguard: ensure actors is never nil. Delay issues.
                                            name: actor.name.isEmpty ? "Unknown" : actor.name,
                                            imageURL: actor.image
                                        )
                                    }
                                }
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
                        AddReviewView(movieId: movie.id)
                }
                .padding([.top,.bottom], 32)

            }
        }
        .coordinateSpace(name: "scroll")
        .background(Color.black.ignoresSafeArea())
        .foregroundColor(.light1)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            // Leading: Custom Back Button
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "arrow.backward")
                        .foregroundColor(.brandMain)
                }
            }
            // Trailing: Share Button
            ToolbarItem(placement: .navigationBarTrailing) {
                HStack(spacing: 16) {
                    Button(action: {
                        // TODO: share movie placeholder
                        print("Share tapped")
                    }) {
                        Image(systemName: "square.and.arrow.up")
                            .foregroundColor(.brandMain)
                    }
                    
                    Button(action: {
                        // TODO: save movie placeholder
                        print("Save tapped")
                    }) {
                        Image(systemName: "bookmark")
                            .foregroundColor(.brandMain)
                    }
                }
            }
        }
        .task {
            await movieDetailsVM.fetchActors(for: movie)
            await movieDetailsVM.fetchDirectors(for: movie)
        }
    }
}

#Preview {
    let movie = MovieModel(
        id: "recfNj1e4waOUJLxd",
        name: "The Shawshank Redemption",
        poster: "...",
        story: "...",
        runtime: "2h 22m",
        genre: ["Drama"],
        rating: "R",
        imdbRating: 9.3,
        language: ["English"]
    )

    MovieDetailsView(movie: movie)
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
    let imageURL: String

    var body: some View {
        VStack{
            AsyncImage(url: URL(string: imageURL)) { image in
                image
                    .resizable()
                    .scaledToFill()
            } placeholder: {
                Color.gray.opacity(0.3)
            }
            .frame(width: 76, height: 76)
            .clipShape(Circle())
            // Safeguard
            Text(name.isEmpty ? "Unknown" : name)
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

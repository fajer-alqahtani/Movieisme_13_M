//
//  MoviesView.swift
//  Movieisme_13_M
//
//  Created by Yousra Abdelrahman on 04/07/1447 AH.
//
import SwiftUI

struct MoviesView: View {
    //    let user: SignInUserModel
    @EnvironmentObject var signInVM: SignInViewModel
    
    
    @StateObject private var movieVM = MovieViewModel()
    @State private var searchText: String = ""
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading) {
                    //Header
                    VStack(alignment: .leading) {
                        HStack {
                            Text("Movies Center")
                                .font(.title2)
                                .fontWeight(.bold)
                            Spacer()
                            // Avatar المستخدم -> NavigationLink إلى البروفايل
                            NavigationLink {
                                ProfileView()
                            } label: {
                                UserAvatarView(imageURLString: signInVM.signedInUser?.profileImage ?? "")
                                    .frame(width: 41, height: 41)
                                    .padding(.bottom, 8)
                            }
                            .buttonStyle(.plain)
                        }
                        SearchBarView(text: $searchText)
                            .padding( .bottom, 16)
                    }
                    .padding(.horizontal)
                    
                    if !searchText.isEmpty {
                        VStack(alignment: .leading, spacing: 16) {
                            ForEach(movieVM.filteredMovies(searchText: searchText)) { movie in
                                MoviePoster(movie: movie)
                            }
                        }
                        .padding(.horizontal)
                    } else {
                        //High Rated
                        SectionHeader(title: "High Rated", showMore: false)
                        HighRatedTab(movies: movieVM.highRatedMovies)
                        //Drama
                        SectionHeader(title: "Drama")
                        //Data from API
                        MovieRow(movies: movieVM.dramaMovies)
                            .padding(.bottom, 32)
                        //Comedy
                        SectionHeader(title: "Comedy")
                        //Data from API
                        MovieRow(movies: movieVM.comedyMovies)
                    }
                }
            }
            //A modifier, runs once when the view appears. Safe place to call async code.
            .task {
                await movieVM.loadMovies()
            }
            .background(Color.black.ignoresSafeArea())
            .foregroundColor(.light1)
            // ✅ Here: declare navigationDestination
            .navigationDestination(for: MovieModel.self) { movie in
                MovieDetailsView(movie: movie)
            }
        }
    }
}
//
//#Preview {
//    let signInVM = SignInViewModel()
//    signInVM.signedInUser = SignInUserModel(
//        id: "preview",
//        name: "Preview User",
//        email: "preview@example.com",
//        profileImage: "https://i.pinimg.com/736x/00/47/00/004700cb81873e839ceaadf9f3c1fb28.jpg"
//    )
//
//    return MoviesView()
//        .environmentObject(signInVM)
//        .preferredColorScheme(.dark)
//}


//MARK: - Search Bar View
private struct SearchBarView: View {
    @Binding var text: String
    
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.dark3)
            TextField("Search for Movie name, actors ..." , text: $text)
                .foregroundColor(.dark4)
                .font(.subheadline)
            Spacer()
        }
        .padding()
        .background(Color.white.opacity(0.1))
        .frame(width: 358, height: 36)
        .cornerRadius(10)
    }
}
//MARK: - Section Header View
private struct SectionHeader: View {
    let title: String
    var showMore: Bool = true
    var body: some View {
        HStack {
            Text(title)
                .font(.title3)
                .fontWeight(.semibold)
            Spacer()
            if showMore {
                Button{}
                    label: {
                    Text("Show more")
                        .font(.system(size: 14))
                        .fontWeight(.medium)
                        .foregroundColor(.brandMain)
                }
            }
        }
        .padding(.horizontal)
    }
}
//MARK: - High Rated Tab View
private struct HighRatedTab: View {
    let movies: [MovieModel]
    
    var body: some View {
        TabView {
            ForEach(movies) { movie in
//                HighRatedCard(movie: movie)
                NavigationLink(value: movie) {
                    HighRatedCard(movie: movie)
                }
            }
            .frame(width: 355, height: 424)
            .frame(maxHeight: .infinity, alignment: .top)
        }
        .frame(height: 488)
        .tabViewStyle(.page(indexDisplayMode: .always))
    }
}
//MARK: - High Rated Card View
private struct HighRatedCard: View {
    let movie: MovieModel

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            AsyncImage(url: URL(string: movie.poster)) { image in
                image.resizable().scaledToFill()
            } placeholder: {
                Color.dark2
            }
            .frame(width: 355, height: 424)
            .clipped()
            .cornerRadius(8)

            LinearGradient(
                gradient: Gradient(colors: [.clear, .black.opacity(0.82)]),
                startPoint: .top,
                endPoint: .bottom
            )

            VStack(alignment: .leading, spacing: 6) {
                Text(movie.name)
                    .font(.title2)
                    .fontWeight(.bold)

                HStack(spacing: 0) {
                    ForEach(0..<5) { index in
                        Image(systemName: index < Int(movie.imdbRating/2) ? "star.fill" : "star")
                    }
                    .foregroundColor(.brandMain)
                    .font(.system(size: 7.35))
                }

                HStack(alignment: .bottom) {
                    Text(String(format: "%.1f", movie.imdbRating))
                        .font(.system(size: 20))
                        .fontWeight(.medium)
                    Text("out of 10")
                        .font(.caption)
                        .fontWeight(.medium)
                }

                Text("\(movie.genre.joined(separator: " • ")) • \(movie.runtime)")
                    .font(.caption)
                    .foregroundColor(.dark4)
            }
            .padding([.leading, .bottom], 13)
        }
        .padding(.horizontal)
    }
}

//MARK: - Movie Row View of Posters
private struct MovieRow: View {
    let movies: [MovieModel]
    var body: some View {
        ScrollView(.horizontal) {
            LazyHStack(spacing: 18) {
                //id: \.id identifier
                ForEach(movies) { movie in
//                    MoviePoster(movie: movie)
                    NavigationLink(value: movie) {
                        MoviePoster(movie: movie)
                    }
                }
            }
            .padding(.horizontal)
        }
    }
}
//MARK: - Movie Poster View
private struct MoviePoster: View {
    let movie: MovieModel
    var body: some View {
        VStack(alignment: .leading) {
            //AsyncImage downloads image from the internet
            AsyncImage(url: URL(string: movie.poster)) { image in
                image
                    .resizable()
                    .scaledToFill()
            } placeholder: {
                Color.dark2
            }
            .frame(width: 208, height: 275)
            .cornerRadius(8)
            Text(movie.name)
                .font(.caption)
                .lineLimit(1)
        }
    }
}


//
//  MoviesView.swift
//  Movieisme_13_M
//
//  Created by Yousra Abdelrahman on 04/07/1447 AH.
//
import SwiftUI

struct MovieView: View {

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 28) {

                //Header
                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        Text("Movies Center")
                            .font(.largeTitle)
                            .fontWeight(.bold)

                        Spacer()

                        Circle()
                            .fill(Color.gray.opacity(0.3))
                            .frame(width: 36, height: 36)
                    }

                    SearchBarView()
                }
                .padding(.horizontal)

                //High Rated
                SectionHeader(title: "High Rated")

                HighRatedCarousel()

                //Drama
                SectionHeader(title: "Drama", showMore: true)

                MovieGrid()

                //Comedy
                SectionHeader(title: "Comedy", showMore: true)

                MovieGrid()
            }
            .padding(.bottom, 32)
        }
        .background(Color.black.ignoresSafeArea())
        .foregroundColor(.white)
    }
}

#Preview {
    MovieView()
}


//MARK: - The views are segmented below
//SearchBarView
struct SearchBarView: View {
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.secondary)

            Text("Search for Movie name, actors ...")
                .foregroundColor(.secondary)
                .font(.subheadline)

            Spacer()
        }
        .padding()
        .background(Color.white.opacity(0.1))
        .cornerRadius(12)
    }
}

//SectionHeader
struct SectionHeader: View {
    let title: String
    var showMore: Bool = false

    var body: some View {
        HStack {
            Text(title)
                .font(.headline)

            Spacer()

            if showMore {
                Text("Show more")
                    .font(.caption)
                    .foregroundColor(.yellow)
            }
        }
        .padding(.horizontal)
    }
}

//HighRatedCarousel
struct HighRatedCarousel: View {
    var body: some View {
        TabView {
            HighRatedCard()
            HighRatedCard()
            HighRatedCard()
        }
        .frame(height: 420)
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
    }
}

//HighRatedCard
struct HighRatedCard: View {
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            Image("topGun")
                .resizable()
                .scaledToFill()
                .frame(height: 420)
                .clipped()
                .cornerRadius(20)

            LinearGradient(
                gradient: Gradient(colors: [.clear, .black.opacity(0.9)]),
                startPoint: .top,
                endPoint: .bottom
            )

            VStack(alignment: .leading, spacing: 8) {
                Text("Top Gun")
                    .font(.title)
                    .fontWeight(.bold)

                HStack(spacing: 6) {
                    Image(systemName: "star.fill")
                        .foregroundColor(.yellow)

                    Text("4.8 out of 5")
                        .font(.caption)
                }

                Text("Action • 2 hr 9 min")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding()
        }
        .padding(.horizontal)
    }
}

//MovieGrid
//A grid is a layout system that arranges items in rows and columns.
struct MovieGrid: View {
    let columns = [
        //2 columns, Each column takes equal width
        //Responsive to screen size
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]

    //LazyVGrid creates a vertical grid layout where:
    var body: some View {
        
        LazyHGrid(rows: columns, spacing: 16) {
            MoviePoster(moviePoster: "topGun")
            MoviePoster(moviePoster: "topGun")
        }
        .padding(.horizontal)
    }
}

struct MoviePoster: View {
    let moviePoster: String
    var body: some View {
        Image(moviePoster)
            .resizable()
            .scaledToFill()
            .frame(height: 240)
            .clipped()
            .cornerRadius(16)
    }
}

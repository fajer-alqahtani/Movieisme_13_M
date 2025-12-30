//
//  MoviesDetailsView.swift
//  Movieisme_13_M
//
//  Created by Yousra Abdelrahman on 04/07/1447 AH.
//

import SwiftUI

struct MovieDetailsView: View {
    @State private var showAddReview = false
    let movieId: Int

    var body: some View {
        ScrollView{
            LazyVStack(alignment: .leading, spacing: 24) {
                //Header Image
                HeaderImage()
                    .padding(.top, -60)
                
                //Movie Meta Info
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
                
                //Story
                SectionView(title: "Story") {
                    Text(
                        "In 1947, Andy Dufresne (Tim Robbins), a banker from Maine, is convicted of murdering his wife and her lover, a golf pro. Since the state of Maine has no death penalty, he is given two consecutive life sentences and sent to the notoriously harsh Shawshank Prison."
                    )
                    .font(.system(size: 15))
                    .fontWeight(.medium)
                    .foregroundColor(.dark4)
                }
                
                //IMDb Rating
                SectionView(title: "IMDb Rating") {
                    Text("9.3 / 10")
                        .font(.system(size: 15))
                        .fontWeight(.medium)
                        .foregroundColor(.dark4)
                }
                
                //Director
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
                
                //Stars
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
                //Rating & Reviews
                SectionView(title: "Rating & Reviews") {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("4.8")
                            .font(.largeTitle)
                            .foregroundColor(.dark4)
                            .fontWeight(.semibold)
                        
                        Text("out of 5")
                            .font(.system(size: 15))
                            .foregroundColor(.dark4)
                            .fontWeight(.semibold)
                        
                        ReviewCard(
                            author: "Afnan Abdullah",
                            review: "This is an engagingly simple, good-hearted film, with just enough darkness around the edges to give contrast and relief to its glowingly benign view of human nature.",
                            reviewDay: "Tuesday"
                        )
                        .padding(.top, 16)
                    }

                //Rating & Reviews (Updated: mock now, ready for API later)
                SectionView(title: "Rating & Reviews") {
                    ReviewsSection()
                }
                
            }
            //WriteAReviewButton
            WriteAReviewButton()
                .padding([.top,.bottom], 32)
            WriteAReviewButton {
                showAddReview = true
            }
            .sheet(isPresented: $showAddReview) {
                AddReviewView(movieId: movieId)
            }
            .padding([.top,.bottom], 32)
            
        }
        .coordinateSpace(name: "scroll")
        .background(Color.black.ignoresSafeArea())
        .foregroundColor(.light1)
    }
}

#Preview {
    MovieDetailsView()
    MovieDetailsView(movieId: 1)
}

// MARK: - Header Image
private struct HeaderImage: View{
     var body: some View {
        
            ZStack(alignment: .bottomLeading) {
                Image("topGun")
                    .resizable()
                    .scaledToFill()

                LinearGradient(
                    gradient: Gradient(colors: [.clear, .black.opacity(0.82)]),
                    startPoint: .top,
                    endPoint: .bottom
                )

                Text("Shawshank")
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding()
            }
            .frame(height: 448)

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            Image("topGun")
                .resizable()
                .scaledToFill()

            LinearGradient(
                gradient: Gradient(colors: [.clear, .black.opacity(0.82)]),
                startPoint: .top,
                endPoint: .bottom
            )

            Text("Shawshank")
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
//Declares a generic SwiftUI view
//<Content: View> means it can hold any SwiftUI view(s) as its content
struct SectionView<Content: View>: View {
    let title: String
    let content: Content
    
    //Custom initializer lets you pass the section’s content as a closure
    //@ViewBuilder allows multiple views inside the closure without wrapping them in a single container manually
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

// MARK: - Review Card (NEEDS A MODEL TO IMPLEMENT THE SWIPTING CARDS)
// MARK: - Review Card
struct ReviewCard: View {
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

                VStack (alignment: .leading){
                    Text(author)
                        .font(.system(size: 13))
                        .fontWeight(.semibold)
                    HStack(spacing: 0) {
                        Group{
                            Image(systemName: "star.fill")
                            Image(systemName: "star.fill")
                            Image(systemName: "star.fill")
                            Image(systemName: "star.fill")
                            Image(systemName: "star")
                            
                        }
                        .foregroundColor(.brandMain)
                        .font(.system(size: 7.35))
                    }
                }
            }

                    HStack(spacing: 2) {
                        ForEach(1...5, id: \.self) { i in
                            Image(systemName: i <= rating ? "star.fill" : "star")
                                .foregroundColor(.brandMain)
                                .font(.system(size: 7.35))
                        }
                    }
                }
            }

            Text(review)
                .font(.system(size: 13))
                .fontWeight(.regular)
                .foregroundColor(.light1)

            HStack{
                Spacer()
                Text(reviewDay)
                    .font(.system(size: 13))
                    .fontWeight(.regular)
                    .foregroundColor(.dark4)
                    .multilineTextAlignment(.trailing)
            }
        }
        .padding()
        .background(Color.dark1)
        .cornerRadius(8)
    }
}


//MARK: - Write a Review button
struct WriteAReviewButton: View {
    var body: some View {
        Button {
        } label:{
            Image(systemName: "square.and.pencil")
            Text("Write a review")
                
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

// MARK: - Reviews Section (Mock now, ready for API later)
private struct ReviewsSection: View {

    // Dummy reviews for now (replace later with API data)
    private let reviews: [MockReview] = [
        MockReview(
            author: "Afnan Abdullah",
            review: "This is an engagingly simple, good-hearted film, with just enough darkness around the edges to give contrast and relief to its glowingly benign view of human nature.",
            day: "Tuesday",
            rating: 4
        ),
        MockReview(
            author: "Sarah Abdullah",
            review: "Great movie. The acting is strong and the story stays with you.",
            day: "Yesterday",
            rating: 5
        ),
        MockReview(
            author: "Dana Mohammed",
            review: "Loved the soundtrack and the cinematography. Very immersive!",
            day: "Monday",
            rating: 4
        )
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {

            Text("4.8")
                .font(.largeTitle)
                .foregroundColor(.dark4)
                .fontWeight(.semibold)

            Text("out of 5")
                .font(.system(size: 15))
                .foregroundColor(.dark4)
                .fontWeight(.semibold)

            // Swipe reviews horizontally
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(reviews) { r in
                        ReviewCard(
                            author: r.author,
                            review: r.review,
                            reviewDay: r.day,
                            rating: r.rating
                        )
                        .frame(width: 320)
                    }
                }
                .padding(.top, 16)
                .padding(.horizontal, 2)
            }
        }
    }
}




//
//  MoviesView.swift
//  Movieisme_13_M
//
//  Created by Yousra Abdelrahman on 04/07/1447 AH.
//

import SwiftUI
struct MovieView: View {
    @State private var searchText: String = ""
    
    var body: some View {
        
        ZStack{
            Color.black.ignoresSafeArea(.all)
            ScrollView{
                LazyVStack{
                    HStack{
                        Text("Movie Center")
                            .foregroundStyle(Color.white)
                        Spacer()
                        Image(systemName: "book.circle")
                            .foregroundStyle(Color.white)
                    }
                    TextField("Search...", text: $searchText)
                        .background(Color(.systemGray6))
                        .foregroundStyle(Color.white)
                    Text("High Rated")
                        .foregroundStyle(Color.white)
                    
                    ZStack(alignment: .bottom){
                        Image("image-placeholder")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 600, height: 400)
                        VStack(alignment: .leading){
                            Text("#MovieName")
                                .foregroundStyle(Color.black)
                            Image(systemName: "star.fill")
                                .foregroundStyle(Color.black)
                            Text("#Description")
                                .foregroundStyle(Color.black)
                        }
                    }
                    Image(systemName: "rectangle.and.pencil.and.ellipsis")
                        .foregroundStyle(Color.white)
                    //rectangle.and.pencil.and.ellipsis
                    HStack{
                        Text("Drama")
                            .foregroundStyle(Color.white)
                        Spacer()
                        Text("Show more")
                            .foregroundStyle(Color.white)
                    }
                    HStack{
                        Image("image-placeholder")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 200, height: 200)
                        Image("image-placeholder")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 200, height: 200)
                    }
                    HStack{
                        Text("Comedy")
                            .foregroundStyle(Color.white)
                        Spacer()
                        Text("Show more")
                            .foregroundStyle(Color.white)
                    }
                    HStack{
                        Image("image-placeholder")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 200, height: 200)
                        Image("image-placeholder")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 200, height: 200)
                    }

                }
                .frame(width: 350)
            }
        }
    }
}

#Preview {
    MovieView()
}

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
                            .font(.system(size: 28, weight: .bold))
                        Spacer()
                        Image("icon")
                    }
                    TextField("Search for Movie name , actors ...", text: $searchText)
                        .font(.system(size: 17))
                        .background(Color(.systemGray6))
                        .foregroundStyle(Color.white)
                    //High Rated Section
                    Text("High Rated")
                        .foregroundStyle(Color.white)
                        .font(.system(size: 26, weight: .semibold))
                    
                    ZStack(alignment: .bottom){
                        Image("topGun")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 366, height: 434)
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
                    HStack{
                        //Drama Section
                        Text("Drama")
                            .foregroundStyle(Color.white)
                            .font(.system(size: 22, weight: .semibold))
                        Spacer()
                        Text("Show more")
                            .foregroundStyle(Color.mainYellow)
                            .font(.system(size: 14, weight: .medium))
                    }
                    HStack{
                        Image("shawshank")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 208, height: 275)
                        Image("aStarIsBorn")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 208, height: 275)
                    }
                    HStack{
                        //Comedy Section
                        Text("Comedy")
                            .foregroundStyle(Color.white)
                            .font(.system(size: 22, weight: .semibold))
                        Spacer()
                        Text("Show more")
                            .foregroundStyle(Color.mainYellow)
                            .font(.system(size: 14, weight: .medium))
                    }
                    HStack{
                        Image("worldsGreatestDad")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 208, height: 275)
                        Image("houseParty")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 208, height: 275)
                    }

                }
                
            }
        }
    }
}

#Preview {
    MovieView()
}

//
//  APIEndPoints.swift
//  Movieisme_13_M
//
//  Created by Yousra Abdelrahman on 12/07/1447 AH.
//

enum GetEndPoints{
    static let movies = "/movies"
    static let actors = "/actors"
    //retrieve specific movie’s actors
    static let movieActorsId = "/movie_actors/:movie_id"
    static let directors = "/directors"
    //retrieve specific movie’s directors
    static let movieDirectorsId = "/directors"
    //retrieve specific movie’s reviews by id
    static let reviewsMovieId = "/reviews/:movie_id"
    static let user = "/user"
    static let savedMovies = "/saved_movies"
}
//create
enum PostEndPoints{
    static let review = "/review"
    static let savedMovies = "/saved_movies"
    
}

enum DelEndPoints{
    static let reviewId = "/review/:id"
    
}
//update
enum PutEndPoints{
    static let userId = "/user/:id"
    
}

//
//  Endpoint.swift
//  Movieisme_13_M
//
//  Created by Yousra Abdelrahman on 14/07/1447 AH.
//
import Foundation

enum Endpoint {

    // MARK: - Movies
    case movies
    case movieActors(movieId: Int)
    case movieDirectors(movieId: Int)

    // MARK: - People
    case actors
    case directors

    // MARK: - Reviews
    case reviews(movieId: Int)
    case createReview
    case deleteReview(id: Int)

    // MARK: - User
    case user
    case updateUser(id: Int)

    // MARK: - Saved Movies
    case savedMovies
}


// MARK: - Path
extension Endpoint {
    var path: String {
        switch self {

        case .movies:
            return APIConfig.basePath + "/movies"

        case .actors:
            return APIConfig.basePath + "/actors"

        case .directors:
            return APIConfig.basePath + "/directors"

        case .movieActors(let movieId):
            return APIConfig.basePath + "/movie_actors/\(movieId)"

        case .movieDirectors(let movieId):
            return APIConfig.basePath + "/movie_directors/\(movieId)"

        case .reviews(let movieId):
            return APIConfig.basePath + "/reviews/\(movieId)"

        case .createReview:
            return APIConfig.basePath + "/review"

        case .deleteReview(let id):
            return APIConfig.basePath + "/review/\(id)"

        case .user:
            return APIConfig.basePath + "/user"

        case .updateUser(let id):
            return APIConfig.basePath + "/user/\(id)"

        case .savedMovies:
            return APIConfig.basePath + "/saved_movies"
        }
    }
}



// MARK: - Method
extension Endpoint {
    var method: HTTPMethod {
        switch self {
        case .movies,
             .actors,
             .directors,
             .movieActors,
             .movieDirectors,
             .reviews,
             .user,
             .savedMovies:
            return .get

        case .createReview:
            return .post

        case .updateUser:
            return .put

        case .deleteReview:
            return .delete
        }
    }
}

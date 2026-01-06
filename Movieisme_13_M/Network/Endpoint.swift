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
    case movieActors(movieId: String)
    case movieDirectors(movieId: String)
    
    // MARK: - People
    case actors
    case directors
    
    // MARK: - Reviews
    case reviews(movieId: String)
    case createReview
    case deleteReview(id: Int)
    
    // MARK: - User
    case users
    case usersFiltered(formula: String)
    case updateUser(id: String)
    
    // MARK: - Saved Movies
    case savedMovies
    case savedMoviesFiltered(formula: String)
    
    
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

        case .movieActors:
            return APIConfig.basePath + "/movie_actors"

        case .movieDirectors:
            return APIConfig.basePath + "/movie_directors"

        case .reviews:
            return APIConfig.basePath + "/reviews"

        case .createReview:
            return APIConfig.basePath + "/reviews"

        case .deleteReview(let id):
            return APIConfig.basePath + "/review/\(id)"

        case .users, .usersFiltered:
            return APIConfig.basePath + "/users"

        case .updateUser(let id):
            return APIConfig.basePath + "/users/\(id)"

        case .savedMovies, .savedMoviesFiltered:
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
             .users,
             .usersFiltered,
             .savedMovies,
             .savedMoviesFiltered:
            return .get

        case .createReview:
            return .post

        case .updateUser:
            return .patch

        case .deleteReview:
            return .delete
        }
    }
}

// MARK: - Query Items
extension Endpoint {
    var queryItems: [URLQueryItem]? {
        switch self {
        case .usersFiltered(let formula),
             .savedMoviesFiltered(let formula):
            return [URLQueryItem(name: "filterByFormula", value: formula)]
            
        case .movieActors(let movieId):
            let formula = "movie_id='\(movieId)'" // Airtable formula
            return [URLQueryItem(
                name: "filterByFormula",
                value: formula.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            )]
        // Allow fetching directors for a specific movie
        case .movieDirectors(let movieId):
            let formula = "movie_id='\(movieId)'" // Airtable formula
            return [URLQueryItem(
                name: "filterByFormula",
                value: formula.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            )]
        default:
            return nil
        }
    }
}





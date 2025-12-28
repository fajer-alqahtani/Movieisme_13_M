//
//  MovieModel.swift
//  Movieisme_13_M
//
//  Created by Yousra Abdelrahman on 04/07/1447 AH.
//
struct MovieModel: Codable{
    var name: String
    var poster: String
    var story: String
    var runtime: String
    var genre: [String]
    var rating: String
    //snake_case
    var IMDbRating: Double
    var language: [String]
    
    enum CodingKeys: String, CodingKey {
        case name
        case poster
        case story
        case runtime
        case genre
        case rating
        case IMDbRating = "IMDb_rating"
        case language
    }
    
}

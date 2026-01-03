//
//  MovieModel.swift
//  Movieisme_13_M
//
//  Created by Yousra Abdelrahman on 04/07/1447 AH.
//Third Layer of JSON
//
import Foundation
struct MovieModel: Codable {
    let name: String
    let poster: String
    let story: String
    let runtime: String
    let genre: [String]
    let rating: String
    let imdbRating: Double
    let language: [String]

    enum CodingKeys: String, CodingKey {
        case name
        case poster
        case story
        case runtime
        case genre
        case rating
        case imdbRating = "IMDb_rating"
        case language
    }
}


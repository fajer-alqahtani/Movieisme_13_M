//
//  MovieModel.swift
//  Movieisme_13_M
//
//  Created by Yousra Abdelrahman on 04/07/1447 AH.
//Third Layer of JSON
//
import Foundation
struct MovieModel: Identifiable, Hashable{
    // id comes from MovieRecordModel
    let id: String
    let name: String
    let poster: String
    let story: String
    let runtime: String
    let genre: [String]
    let rating: String
    let imdbRating: Double
    let language: [String]
    //Safeguard
    init(
        id: String = "",
        name: String = "Unknown",
        poster: String = "",
        story: String = "",
        runtime: String = "N/A",
        genre: [String] = [],
        rating: String = "N/A",
        imdbRating: Double = 0.0,
        language: [String] = []
    ) {
        self.id = id
        self.name = name
        self.poster = poster
        self.story = story
        self.runtime = runtime
        self.genre = genre
        self.rating = rating
        self.imdbRating = imdbRating
        self.language = language
    }
}
//Data Transfer Objects
struct MovieFieldsDTO: Decodable {
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

//Second Layer of JSON
import Foundation
import Combine
struct MovieRecordModel: Decodable, Identifiable {
    let id: String
    let fields: MovieFieldsDTO
}

//First Layer of JSON
struct MovieResponseModel: Decodable {
    let records: [MovieRecordModel]
}

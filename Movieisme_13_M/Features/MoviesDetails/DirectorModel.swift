//
//  DirectorModel.swift
//  Movieisme_13_M
//
//  Created by Yousra Abdelrahman on 17/07/1447 AH.
//


import Foundation

struct DirectorModel: Identifiable {
    let id: String
    let name: String
    let image: String
    init(id: String, name: String?, image: String?) {
        self.id = id
        self.name = name ?? "Unknown"
        self.image = image ?? ""
    }
}

// Airtable response models
struct DirectorResponseModel: Decodable {
    let records: [DirectorRecordDTO]
}

struct DirectorRecordDTO: Decodable {
    let id: String
    let fields: DirectorFieldsDTO
}

struct DirectorFieldsDTO: Decodable {
    let name: String
    let image: String
}

// Join table: movie_directors
struct MovieDirectorResponseModel: Decodable {
    let records: [MovieDirectorRecordDTO]
}

struct MovieDirectorRecordDTO: Decodable {
    let id: String
    let fields: MovieDirectorFieldsDTO
}

struct MovieDirectorFieldsDTO: Decodable {
    let movieId: String
    let directorId: String

    enum CodingKeys: String, CodingKey {
        case movieId = "movie_id"
        case directorId = "director_id"
    }
}

//
//  MovieActorModel.swift
//  Movieisme_13_M
//
//  Created by Yousra Abdelrahman on 17/07/1447 AH.
//
struct MovieActorModel {
    let movieId: String
    let actorId: String
}

struct MovieActorResponseModel: Decodable {
    let records: [MovieActorRecordDTO]
}

struct MovieActorRecordDTO: Decodable {
    let id: String
    let fields: MovieActorFieldsDTO
}

struct MovieActorFieldsDTO: Decodable {
    let movieId: String
    let actorId: String

    enum CodingKeys: String, CodingKey {
        case movieId = "movie_id"
        case actorId = "actor_id"
    }
}

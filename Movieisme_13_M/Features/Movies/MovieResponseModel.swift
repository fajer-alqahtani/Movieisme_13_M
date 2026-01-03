//
//  MovieResponseModel.swift
//  Movieisme_13_M
//
//  Created by Yousra Abdelrahman on 08/07/1447 AH.
//
//First Layer of JSON
struct MovieResponseModel: Decodable {
    let records: [MovieRecordModel]
}


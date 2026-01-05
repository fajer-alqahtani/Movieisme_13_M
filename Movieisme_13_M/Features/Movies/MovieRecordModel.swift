//
//  MovieRecordModel.swift
//  Movieisme_13_M
//
//  Created by Yousra Abdelrahman on 08/07/1447 AH.
//
//Second Layer of JSON
import Foundation
import Combine
struct MovieRecordModel: Decodable, Identifiable {
    let id: String
    let fields: MovieFieldsDTO
}

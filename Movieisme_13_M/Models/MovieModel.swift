//
//  MovieModel.swift
//  Movieisme_13_M
//
//  Created by Yousra Abdelrahman on 04/07/1447 AH.
//Third Layer of JSON
//
import Foundation
struct MovieModel: Identifiable, Codable {
    let id = UUID()   // for SwiftUI
    let name: String
    let poster: String
    let genre: [String]
    enum CodingKeys: String, CodingKey {
        case name
        case poster
        case genre
    }
}

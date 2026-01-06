//
//  ActorsModel.swift
//  Movieisme_13_M
//
//  Created by Yousra Abdelrahman on 17/07/1447 AH.
//

import Foundation

struct ActorModel: Identifiable, Hashable {
    let id: String
    let name: String
    let image: String
    init(id: String, name: String?, image: String?) {
        self.id = id
        self.name = name ?? "Unknown"
        self.image = image ?? ""
    }
}

//Third Layer of JSON
struct ActorFieldsDTO: Decodable {
    let name: String
    let image: String
}

//Second Layer of JSON
struct ActorRecordModel: Decodable, Identifiable {
    let id: String
    let fields: ActorFieldsDTO
}

//First Layer of JSON
struct ActorResponseModel: Decodable {
    let records: [ActorRecordModel]
}



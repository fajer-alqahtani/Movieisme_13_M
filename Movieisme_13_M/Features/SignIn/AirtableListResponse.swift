//
//  AirtableListResponse.swift
//  Movieisme_13_M
//
//  Created by asma  on 16/07/1447 AH.
//

//
//  AirtableUsersModels.swift
//  Movieisme_13_M
//

import Foundation

// Generic Airtable list response
struct AirtableListResponse<RecordFields: Decodable>: Decodable {
    let records: [AirtableRecord<RecordFields>]
}

struct AirtableRecord<Fields: Decodable>: Decodable {
    let id: String
    let fields: Fields
    let createdTime: String?
}

// Users table fields (حسب ما ورد في Postman: email, password, name, profile_image)
struct AirtableUserFields: Decodable {
    let email: String
    let password: String? // ⚠️ optional
    let name: String?
    let profile_image: String?
}



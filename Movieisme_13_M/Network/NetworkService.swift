//
//  API.swift
//  Movieisme_13_M
//
//  Created by Yousra Abdelrahman on 04/07/1447 AH.
//


//
//  NetworkService.swift
//  Movieisme_13_M
//
//  Created by Yousra Abdelrahman on 10/07/1447 AH.
//
import Foundation
func fetchMovies() async throws -> [MovieModel] {
    
    var components = URLComponents()
    components.scheme = "https"
    components.host = "api.airtable.com"
    components.path = "/v0/appsfcB6YESLj4NCN/movies"
    let url = components.url!
    
    var request = URLRequest(url: url)
    request.httpMethod = "GET"
    request.setValue(
        Token.airtableToken,
        forHTTPHeaderField: "Authorization"
    )
    let (data, _) = try await URLSession.shared.data(for: request)
    let response = try JSONDecoder().decode(MovieResponseModel.self, from: data)
    return response.records.map { $0.fields }
}




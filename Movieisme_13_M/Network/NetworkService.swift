//
//  NetworkService.swift
//  Movieisme_13_M
//
//  Created by Yousra Abdelrahman on 04/07/1447 AH.
//

import Foundation

final class NetworkService {
    static let shared = NetworkService()
    private init() {}
    func request<T: Decodable>(
        endpoint: Endpoint,
        responseType: T.Type
    ) async throws -> T {

        guard let url = URLBuilder.makeURL(for: endpoint) else {
            throw URLError(.badURL)
        }

        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        request.setValue(
            Token.airtableToken,
            forHTTPHeaderField: "Authorization"
        )

        let (data, _) = try await URLSession.shared.data(for: request)
        return try JSONDecoder().decode(T.self, from: data)
    }
}

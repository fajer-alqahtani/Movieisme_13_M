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
        request.setValue(Token.airtableToken, forHTTPHeaderField: "Authorization")

        let (data, response) = try await URLSession.shared.data(for: request)

        let raw = String(data: data, encoding: .utf8) ?? "nil"
        if let http = response as? HTTPURLResponse {
            print("➡️ \(endpoint.method.rawValue) \(url.absoluteString)")
            print("📥 Status:", http.statusCode)
            print("📥 Response:", raw)
        }

        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }

        guard (200...299).contains(httpResponse.statusCode) else {
            throw NSError(
                domain: "NetworkService",
                code: httpResponse.statusCode,
                userInfo: [NSLocalizedDescriptionKey: raw]
            )
        }

        return try JSONDecoder().decode(T.self, from: data)
    }

    // MARK: - Request مع Body (PATCH/POST/PUT)
    func request<T: Decodable>(
        endpoint: Endpoint,
        body: Data,
        responseType: T.Type
    ) async throws -> T {

        guard let url = URLBuilder.makeURL(for: endpoint) else {
            throw URLError(.badURL)
        }

        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        request.setValue(Token.airtableToken, forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = body

        let (data, response) = try await URLSession.shared.data(for: request)

        let raw = String(data: data, encoding: .utf8) ?? "nil"
        print("➡️ \(endpoint.method.rawValue) \(url.absoluteString)")
        print("📦 Body:", String(data: body, encoding: .utf8) ?? "nil")
        if let http = response as? HTTPURLResponse {
            print("📥 Status:", http.statusCode)
        }
        print("📥 Response:", raw)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }

        guard (200...299).contains(httpResponse.statusCode) else {
            throw NSError(
                domain: "NetworkService",
                code: httpResponse.statusCode,
                userInfo: [NSLocalizedDescriptionKey: raw]
            )
        }

        return try JSONDecoder().decode(T.self, from: data)
    }
}


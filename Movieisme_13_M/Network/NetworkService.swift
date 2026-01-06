import Foundation

//Network layer that: Sends HTTP requests, Validates responses, Decodes JSON into models
final class NetworkService {
    static let shared = NetworkService()
    private init() {}

    func request<T: Decodable>(
        endpoint: Endpoint,
        responseType: T.Type
    ) async throws -> T {

        guard let url = URLBuilder.makeURL(for: endpoint) else {
            throw AppError.invalidURL
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
            throw AppError.invalidResponse
        }

        guard (200...299).contains(httpResponse.statusCode) else {
            throw AppError.httpStatus(httpResponse.statusCode)
        }
        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            print("❌ Decoding error:", error)
            throw AppError.map(error)
        }

    }

    // MARK: - Request with ‎Body (POST/PUT)
    func request<T: Decodable>(
        endpoint: Endpoint,
        body: Data,
        responseType: T.Type
    ) async throws -> T {

        guard let url = URLBuilder.makeURL(for: endpoint) else {
            throw AppError.invalidURL
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
            throw AppError.invalidResponse
        }

        guard (200...299).contains(httpResponse.statusCode) else {
            throw AppError.httpStatus(httpResponse.statusCode)
        }

        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            print("❌ Decoding error:", error)
            throw AppError.map(error)
        }

    }
}


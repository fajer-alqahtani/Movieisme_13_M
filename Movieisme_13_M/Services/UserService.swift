//
//  UserService.swift
//  Movieisme_13_M
//
//  Created by asma  on 16/07/1447 AH.
//



import Foundation
struct UserService {
/////
    struct UpdateUserFields: Encodable {
        let fields: Fields
        struct Fields: Encodable {
            let name: String
        }
    }

    struct UpdateUserProfileFields: Encodable {
        let fields: Fields
        struct Fields: Encodable {
            let name: String?
            let profile_image: String?
        }
    }

    func updateUserName(recordId: String, newName: String) async throws -> AirtableRecord<AirtableUserFields> {
        let payload = UpdateUserFields(fields: .init(name: newName))
        let body = try JSONEncoder().encode(payload)
print ("hii")
        let updated: AirtableRecord<AirtableUserFields> = try await NetworkService.shared.request(
            endpoint: .updateUser(id: recordId),
            body: body,
            responseType: AirtableRecord<AirtableUserFields>.self
        )
        print ("hii 66")
        return updated
    }

    func updateUserProfile(recordId: String, name: String?, profileImage: String?) async throws -> AirtableRecord<AirtableUserFields> {
        let fields = UpdateUserProfileFields.Fields(
            name: name?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty == false ? name : nil,
            profile_image: profileImage?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty == false ? profileImage : nil
        )

        let payload = UpdateUserProfileFields(fields: fields)
        let body = try JSONEncoder().encode(payload)

        let updated: AirtableRecord<AirtableUserFields> = try await NetworkService.shared.request(
            endpoint: .updateUser(id: recordId),
            body: body,
            responseType: AirtableRecord<AirtableUserFields>.self
        )
        return updated
    }
////

    // Return full records (id + fields) like Airtable gives you
    func fetchUserRecords() async throws -> [UserRecord] {
        let response = try await NetworkService.shared.request(
            endpoint: .users,
            responseType: UsersResponseModel.self
        )
        return response.records
    }

    // Convenience: return app-friendly model
    func fetchUsers() async throws -> [SignInUserModel] {
        let records = try await fetchUserRecords()
        return records.map {
            SignInUserModel(
                id: $0.id,
                name: $0.fields.name ?? "",
                email: $0.fields.email,
                profileImage: $0.fields.profile_image ?? ""
            )
        }
    }

    // Airtable usually doesn't do /users/{id} GET in your Endpoint,
    // so fetch by filterByFormula using RECORD_ID()
    func fetchUserDetails(userId: String) async throws -> UserRecord {
        let escaped = escapeFormula(userId)
        let formula = "RECORD_ID() = \"\(escaped)\""

        let response = try await NetworkService.shared.request(
            endpoint: .usersFiltered(formula: formula),
            responseType: UsersResponseModel.self
        )

        guard let record = response.records.first else {
            throw URLError(.fileDoesNotExist)
        }
        return record
    }

    // Update user information (PUT)
    func updateUser(
        userId: String,
        name: String?,
        email: String,
        password: String?,
        profileImage: String?
    ) async throws -> UserRecord {

        struct UpdateUserBody: Encodable {
            let fields: UserFields
        }

        let body = UpdateUserBody(
            fields: UserFields(
                name: name,
                email: email,
                password: password,
                profile_image: profileImage
            )
        )

        let updated = try await NetworkService.shared.request(
            endpoint: .updateUser(id: userId),
            body: body,
            responseType: UserRecord.self
        )

        return updated
    }

    private func escapeFormula(_ value: String) -> String {
        value.replacingOccurrences(of: "\"", with: "\\\"")
    }

}








import Foundation

extension NetworkService {

    func request<T: Decodable, Body: Encodable>(
        endpoint: Endpoint,
        body: Body,
        responseType: T.Type
    ) async throws -> T {

        guard let url = URLBuilder.makeURL(for: endpoint) else {
            throw URLError(.badURL)
        }

        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        request.setValue(Token.airtableToken, forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        request.httpBody = try JSONEncoder().encode(body)

        let (data, response) = try await URLSession.shared.data(for: request)
        print(String(data: data, encoding: .utf8),"☀️")
        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }

        switch httpResponse.statusCode {
        case 200...299:
            return try JSONDecoder().decode(T.self, from: data)
        default:
            // keep your current behavior (you can throw custom errors later)
            return try JSONDecoder().decode(T.self, from: data)
        }
    }
}


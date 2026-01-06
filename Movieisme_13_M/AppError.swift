//
//  AppError.swift
//  Movieisme_13_M
//
//  Created by Fajer alQahtani on 14/07/1447 AH.
//

import Foundation

// MARK: - AppError
enum AppError: LocalizedError, Equatable {
    case invalidURL
    case invalidResponse
    case httpStatus(Int)
    case decodingFailed
    case encodingFailed
    case emptyData
    case network(URLError)
    case unknown(String)

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL."
        case .invalidResponse:
            return "Invalid server response."
        case .httpStatus(let code):
            return "Request failed (HTTP \(code))."
        case .decodingFailed:
            return "Failed to read data."
        case .encodingFailed:
            return "Failed to send data."
        case .emptyData:
            return "No data received."
        case .network(let err):
            return err.localizedDescription
        case .unknown(let msg):
            return msg
        }
    }
}

// MARK: - Helper (map any Error to AppError)
extension AppError {
    static func map(_ error: Error) -> AppError {
        if let app = error as? AppError { return app }
        if let url = error as? URLError { return .network(url) }
        return .unknown(error.localizedDescription)
    }
}

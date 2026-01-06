//
//  ReviewsSection.swift
//  Movieisme_13_M
//
//  Created by Fajer alQahtani on 16/07/1447 AH.
//
import SwiftUI
import Foundation
import Combine

// MARK: - View

struct ReviewsSection: View {
    let movieName: String  // ✅ نستخدم اسم الفيلم
    @StateObject private var reviewsVM = ReviewsSectionViewModel()

    init(movieName: String) {
        self.movieName = movieName
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            
            // Average
            let avg = reviewsVM.reviews.isEmpty ? 0 :
            (reviewsVM.reviews.compactMap { $0.fields.rate }.reduce(0, +) / Double(reviewsVM.reviews.count))
            
            HStack(alignment: .firstTextBaseline, spacing: 8) {
                Text(String(format: "%.1f", avg))
                    .font(.system(size: 46, weight: .bold))
                    .foregroundColor(.white)
                
                Text("out of 5")
                    .foregroundColor(.gray)
            }
            
            if reviewsVM.isLoading {
                ProgressView()
            } else if let err = reviewsVM.errorMessage {
                Text(err)
                    .foregroundColor(.red)
                    .font(.caption)
            } else if reviewsVM.reviews.isEmpty {
                Text("No reviews yet.")
                    .foregroundColor(.gray)
                    .font(.caption)
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 16) {
                        ForEach(reviewsVM.reviews) { rec in
                            ReviewCards(
                                author: rec.fields.userId ?? "Anonymous",
                                review: rec.fields.reviewText ?? "",
                                reviewDay: rec.createdTime ?? "",
                                rating: Int(rec.fields.rate ?? 0)
                            )
                            .frame(width: 320)
                        }
                    }
                    .padding(.vertical, 6)
                }
            }
        }
        .onAppear {
            reviewsVM.loadReviews(forMovieName: movieName)  // ✅ نستخدم الاسم
        }
    }
}

// MARK: - ViewModel

@MainActor
final class ReviewsSectionViewModel: ObservableObject {
    @Published var reviews: [AirtableReviewRecord] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    private let service = ReviewsAirtableService()
    private var didLoad = false

    var averageRating: Double {
        let values = reviews.compactMap { $0.fields.rate }
        guard !values.isEmpty else { return 0 }
        return values.reduce(0, +) / Double(values.count)
    }

    var averageRatingText: String {
        String(format: "%.1f", averageRating == 0 ? 0 : averageRating)
    }

    func loadReviews(forMovieName name: String) {  // ✅ نستخدم اسم الفيلم
        guard !didLoad else { return }
        didLoad = true

        isLoading = true
        errorMessage = nil
        reviews = []

        Task {
            do {
                // 1️⃣ أولاً: نجيب الـ recordId من اسم الفيلم
                guard let movieRecordId = try await service.fetchMovieRecordId(byName: name) else {
                    self.errorMessage = "Movie '\(name)' not found"
                    self.isLoading = false
                    return
                }
                
                // 2️⃣ ثانياً: نجيب الـ reviews
                let result = try await service.fetchReviews(movieRecordId: movieRecordId)
                self.reviews = result
                self.isLoading = false

            } catch {
                self.isLoading = false
                self.errorMessage = "Reviews error: \(error.localizedDescription)"
            }
        }
    }

    func debugTappedWrite() {
        print("📝 Write review tapped")
    }
}

// MARK: - Airtable Service

final class ReviewsAirtableService {
    
    // ✅ 1️⃣ جيب Movie Record ID من اسم الفيلم
    func fetchMovieRecordId(byName name: String) async throws -> String? {
        // ✅ استخدام SEARCH للبحث عن أي جزء من الاسم
        let formula = "SEARCH(LOWER('\(name)'), LOWER({name}))"
        
        let url = try makeURL(
            table: "Movies",  // ✅ غيّري لاسم جدول الأفلام عندك
            queryItems: [
                URLQueryItem(name: "filterByFormula", value: formula),
                URLQueryItem(name: "maxRecords", value: "1")
            ]
        )
        
        var req = URLRequest(url: url)
        req.httpMethod = "GET"
        req.setValue("application/json", forHTTPHeaderField: "Accept")
        
        let token = Token.airtableToken
        let authValue = token.lowercased().starts(with: "bearer ") ? token : "Bearer \(token)"
        req.setValue(authValue, forHTTPHeaderField: "Authorization")
        
        print("✅ Fetching Movie ID for:", name)
        
        let (data, resp) = try await URLSession.shared.data(for: req)
        
        guard let http = resp as? HTTPURLResponse, http.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        // Decode النتيجة
        let decoded = try JSONDecoder().decode(AirtableMovieListResponse.self, from: data)
        let recordId = decoded.records.first?.id
        
        print("✅ Movie Record ID:", recordId ?? "nil")
        return recordId
    }

    // ✅ 2️⃣ GET Reviews filtered by Airtable linked record id
    func fetchReviews(movieRecordId: String) async throws -> [AirtableReviewRecord] {

        // ✅ إذا movie_id Linked Record (array) نستخدم FIND + ARRAYJOIN
        let formula = "FIND('\(movieRecordId)', ARRAYJOIN({movie_id}))"

        let url = try makeURL(
            table: "Reviews",
            queryItems: [
                URLQueryItem(name: "filterByFormula", value: formula)
                // ✅ تم حذف الـ sort على createdTime
            ]
        )

        var req = URLRequest(url: url)
        req.httpMethod = "GET"
        req.setValue("application/json", forHTTPHeaderField: "Accept")

        // ✅ Authorization صحيح
        let token = Token.airtableToken
        let authValue = token.lowercased().starts(with: "bearer ") ? token : "Bearer \(token)"
        req.setValue(authValue, forHTTPHeaderField: "Authorization")

        print("✅ Reviews Request URL:", url.absoluteString)
        print("✅ Authorization:", req.value(forHTTPHeaderField: "Authorization") ?? "nil")

        let (data, resp) = try await URLSession.shared.data(for: req)

        if let http = resp as? HTTPURLResponse {
            print("✅ Reviews Status Code:", http.statusCode)

            if http.statusCode != 200 {
                let raw = String(data: data, encoding: .utf8) ?? "(no body)"
                print("❌ Non-200 Response:", raw)
                throw URLError(.badServerResponse)
            }
        }

        // اطبعي JSON الخام
        if let raw = String(data: data, encoding: .utf8) {
            print("✅ Reviews RAW Response:\n\(raw)")
        }

        let decoder = JSONDecoder()
        let decoded = try decoder.decode(AirtableReviewListResponse.self, from: data)
        
        // ✅ رتّب البيانات حسب createdTime (الأحدث أولاً)
        let sorted = decoded.records.sorted { record1, record2 in
            guard let time1 = record1.createdTime,
                  let time2 = record2.createdTime else {
                return false
            }
            return time1 > time2  // descending
        }
        
        return sorted
    }

    // MARK: - URL Builder
    private func makeURL(table: String, queryItems: [URLQueryItem]) throws -> URL {
        var comps = URLComponents()
        comps.scheme = APIConfig.scheme
        comps.host = APIConfig.host
        comps.path = APIConfig.basePath + "/\(table)"
        comps.queryItems = queryItems

        guard let url = comps.url else { throw URLError(.badURL) }
        return url
    }
}

// MARK: - Models

struct AirtableReviewListResponse: Decodable {
    let records: [AirtableReviewRecord]
    let offset: String?
}

struct AirtableReviewRecord: Decodable, Identifiable {
    let id: String
    let createdTime: String?
    let fields: AirtableReviewFields
}

struct AirtableReviewFields: Decodable {
    let rate: Double?
    let reviewText: String?
    let movieId: String?
    let userId: String?
    let userName: String?

    enum CodingKeys: String, CodingKey {
        case rate
        case reviewText = "review_text"
        case movieId = "movie_id"
        case userId = "user_id"
        case userName = "user_name"
    }
}

// ✅ Models للـ Movies API (عشان نجيب الـ recordId)
struct AirtableMovieListResponse: Decodable {
    let records: [AirtableMovieRecord]
}

struct AirtableMovieRecord: Decodable {
    let id: String
    let fields: AirtableMovieFields?
}

struct AirtableMovieFields: Decodable {
    let name: String?
}

// MARK: - Helpers

private extension String {
    /// Airtable createdTime usually ISO8601: 2025-01-05T12:34:56.000Z
    var dayNameShort: String? {
        let iso = ISO8601DateFormatter()
        iso.formatOptions = [.withInternetDateTime, .withFractionalSeconds]

        let d1 = iso.date(from: self) ?? ISO8601DateFormatter().date(from: self)
        guard let date = d1 else { return nil }

        let f = DateFormatter()
        f.locale = Locale(identifier: "en_US_POSIX")
        f.dateFormat = "EEEE"   // Tuesday
        return f.string(from: date)
    }
}

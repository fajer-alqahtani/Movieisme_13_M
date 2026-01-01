//
//  ReviewModel.swift
//  Movieisme_13_M
//
//  Created by Fajer alQahtani on 04/07/1447 AH.
//

import Foundation

struct MockReview: Identifiable {
    let id = UUID()
    let author: String
    let review: String
    let day: String
    let rating: Int
}

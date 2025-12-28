//
//  StarRatingView.swift
//  Movieisme_13_M
//
//  Created by Fajer alQahtani on 04/07/1447 AH.
//

import SwiftUI

struct StarRatingView: View {
    @Binding var rating: Int
    var max: Int = 5

    var body: some View {
        HStack(spacing: 10) {
            ForEach(1...max, id: \.self) { i in
                Image(systemName: i <= rating ? "star.fill" : "star")
                    .foregroundColor(.yellow)
                    .font(.system(size: 18, weight: .semibold))
                    .onTapGesture { rating = i }
            }
        }
    }
}

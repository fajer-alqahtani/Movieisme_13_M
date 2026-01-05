//
//  avat.swift
//  Movieisme_13_M
//
//  Created by asma  on 16/07/1447 AH.
//

//
//  UserAvatarView.swift
//  Movieisme_13_M
//
//  Created by asma  on 16/07/1447 AH.
//

import SwiftUI

struct UserAvatarView: View {
    let imageURLString: String
    var size: CGFloat = 41

    var body: some View {
        Group {
            if let url = URL(string: imageURLString),
               !imageURLString.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                AsyncImage(url: url) { image in
                    image.resizable().scaledToFill()
                } placeholder: {
                    Color.gray.opacity(0.3)
                }
            } else {
                Image("avatar")
                    .resizable()
                    .scaledToFill()
            }
        }
        .frame(width: size, height: size)
        .clipShape(Circle())
    }
}


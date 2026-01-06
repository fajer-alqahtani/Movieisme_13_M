//
//  SignInUserModel.swift
//  Movieisme_13_M
//
//  Created by asma  on 16/07/1447 AH.
//

//
//  SignInModel.swift
//  Movieisme_13_M
//
//  Created by asma  on 14/07/1447 AH.
//

//

import Foundation

// MARK: - User shown in the app after sign in
// هذا المودل نستخدمه داخل التطبيق (واجهة – ViewModel)
struct SignInUserModel: Identifiable, Equatable, Hashable {
    let id: String
    let name: String
    let email: String
    let profileImage: String
}

// MARK: - API Response Models (Decodable)
// هذي مطابقة لرد Airtable (JSON)

//// أعلى مستوى
//struct UsersResponseModel: Decodable {
//    let records: [UserRecord]
//}
//
//// كل record
//struct UserRecord: Decodable {
//    let id: String
//    let createdTime: String
//    let fields: UserFields
//}
//
//// البيانات داخل fields
//struct UserFields: Decodable {
//    let name: String
//    let email: String
//    let password: String
//    let profile_image: String
//}
//

// أعلى مستوى
struct UsersResponseModel: Decodable {
    let records: [UserRecord]
}

// كل record
struct UserRecord: Decodable {
    let id: String
    let createdTime: String
    let fields: UserFields
}

// ✅ Make fields flexible + usable for update
struct UserFields: Codable {
    let name: String?
    let email: String
    let password: String?
    let profile_image: String?
}

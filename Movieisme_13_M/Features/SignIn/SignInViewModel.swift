import Foundation
import Combine

@MainActor
final class SignInViewModel: ObservableObject {

    @Published var isLoggedIn: Bool = false

    @Published var email: String = ""
    @Published var password: String = ""
    @Published var showPassword: Bool = false

    @Published var errorMessage: String?
    @Published var isSigningIn: Bool = false

    // MARK: - User
    @Published var signedInUser: SignInUserModel?

    func signIn() {
        Task {
            await performSignIn()
        }
    }

    func signOut() {
        signedInUser = nil
        email = ""
        password = ""
        errorMessage = nil
        isLoggedIn = false
    }

    // MARK: - Private Logic
    private func performSignIn() async {

        let trimmedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedPassword = password.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !trimmedEmail.isEmpty, !trimmedPassword.isEmpty else {
            errorMessage = "الرجاء تعبئة جميع الحقول"
            return
        }

        errorMessage = nil
        isSigningIn = true
        defer { isSigningIn = false }

        let escapedEmail = trimmedEmail.replacingOccurrences(of: "\"", with: "\\\"")
        let escapedPassword = trimmedPassword.replacingOccurrences(of: "\"", with: "\\\"")

        let formula = "AND(email=\"\(escapedEmail)\", password=\"\(escapedPassword)\")"
        print("🔎 Airtable Formula:", formula)

        do {
            let response: AirtableListResponse<AirtableUserFields> =
            try await NetworkService.shared.request(
                endpoint: .usersFiltered(formula: formula),
                responseType: AirtableListResponse<AirtableUserFields>.self
            )

            print("📥 Records count:", response.records.count)

            guard let record = response.records.first else {
                errorMessage = "البريد الإلكتروني أو كلمة المرور غير صحيحة"
                return
            }

            signedInUser = SignInUserModel(
                id: record.id,
                name: record.fields.name ?? "",
                email: record.fields.email,
                profileImage: record.fields.profile_image ?? ""
            )

            print("✅ تم تسجيل الدخول:", record.fields.name ?? "")

            isLoggedIn = true

        } catch {
            errorMessage = "فشل الاتصال بالخادم"
            print("❌ Network/Auth error:", error.localizedDescription)
        }
    }
}


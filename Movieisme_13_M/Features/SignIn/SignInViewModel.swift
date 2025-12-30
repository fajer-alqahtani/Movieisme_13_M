import Foundation
import Combine

@MainActor
final class SignInViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var showPassword: Bool = false
    @Published var errorMessage: String?

    func signIn() {
       
        guard !email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
              !password.isEmpty else {
            errorMessage = "الرجاء تعبئة جميع الحقول"
            return
        }
        errorMessage = nil
        print("تم تسجيل الدخول بنجاح: \(email)")
    }
}

import Foundation
import SwiftUI
import Combine

@MainActor
final class ProfileInfoViewModel: ObservableObject {

    @Published var isEditing: Bool = false

    @Published var firstName: String = ""
    @Published var lastName: String = ""
    @Published var email: String = ""

    @Published var errorMessage: String?

    private let userService = UserService()

    func enterEditMode() {
        errorMessage = nil
        withAnimation(.easeInOut) { isEditing = true }
    }

    func fillFromUser(_ user: SignInUserModel) {
        let parts = user.name.split(separator: " ", maxSplits: 1, omittingEmptySubsequences: true)
        firstName = parts.first.map(String.init) ?? ""
        lastName = parts.count > 1 ? String(parts[1]) : ""
        email = user.email
    }

    func saveChanges(signInVM: SignInViewModel?) {
        errorMessage = nil

        guard let signInVM, let user = signInVM.signedInUser else {
            errorMessage = "ما فيه مستخدم مسجل دخول"
            withAnimation(.easeInOut) { isEditing = false }
            return
        }

        let newFullName = [firstName, lastName]
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }
            .joined(separator: " ")

        let didChangeName = !newFullName.isEmpty && newFullName != user.name

        if !didChangeName {
            withAnimation(.easeInOut) { isEditing = false }
            return
        }

        Task {
            do {
                print("🟡 Updating name to:", newFullName, "for record:", user.id)

                // ✅ نرسل الاسم فقط — بدون صورة
                let updated = try await userService.updateUserProfile(
                    recordId: user.id,
                    name: newFullName,
                    profileImage: nil
                )

                let updatedUser = SignInUserModel(
                    id: updated.id,
                    name: updated.fields.name ?? newFullName,
                    email: user.email,
                    profileImage: user.profileImage
                )

                signInVM.signedInUser = updatedUser


                fillFromUser(updatedUser)

                withAnimation(.easeInOut) { isEditing = false }
                print("✅ Name updated successfully")

            } catch {
                errorMessage = "فشل حفظ الاسم"
                withAnimation(.easeInOut) { isEditing = false }
                print("❌ Update failed:", error.localizedDescription)
            }
        }
    }
}


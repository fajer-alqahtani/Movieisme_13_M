import Foundation
import SwiftUI
import PhotosUI
import Combine

@MainActor
final class ProfileInfoViewModel: ObservableObject {
    @Published var isEditing: Bool = false

    @Published var firstName: String = "Sarah"
    @Published var lastName: String = "Abdullah"
    @Published var email: String = "Xxxx234@gmail.com"

    @Published var selectedPhotoItem: PhotosPickerItem?
    @Published private(set) var profileImageData: Data?

    let defaultAvatarName = "avatar"

    func enterEditMode() {
        withAnimation(.easeInOut) { isEditing = true }
    }

    func saveChanges() {

        withAnimation(.easeInOut) { isEditing = false }
    }

    func signOut() {
        print("Sign out tapped")
    }

    func loadSelectedImage() async {
        guard let item = selectedPhotoItem else { return }
        do {
            if let data = try await item.loadTransferable(type: Data.self) {
                self.profileImageData = data
            }
        } catch {
            print("Failed to load image data:", error)
        }
    }

    func currentSwiftUIImage() -> Image {
        if let data = profileImageData, let ui = UIImage(data: data) {
            return Image(uiImage: ui)
        } else {
            return Image(defaultAvatarName)
        }
    }
}

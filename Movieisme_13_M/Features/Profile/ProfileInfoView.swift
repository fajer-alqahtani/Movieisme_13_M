import SwiftUI
import PhotosUI


struct ProfileInfoView: View {
    @StateObject private var vm = ProfileInfoViewModel()
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(spacing: 0) {
            // Top Bar
            HStack {
                Button {
                    dismiss()
                } label: {
                    HStack(spacing: 6) {
                        Image(systemName: "arrow.left")
                            .font(.system(size: 20, weight: .semibold))
                        Text("Back")
                            .font(.system(size: 18))
                            .fontWeight(.medium)
                    }
                    .foregroundColor(.yellow)
                }

                Spacer()

                Text("Profile info")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.white)

                Spacer()

                Button {
                    if vm.isEditing {
                        vm.saveChanges()
                    } else {
                        vm.enterEditMode()
                    }
                } label: {
                    Text(vm.isEditing ? "Save" : "Edit")
                        .font(.system(size: 18))
                        .fontWeight(.medium)
                        .foregroundColor(.yellow)
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 12)
            .padding(.bottom, 8)

            ScrollView {
                VStack(spacing: 24) {
                    VStack {
                        ZStack(alignment: .bottomTrailing) {
                            vm.currentSwiftUIImage()
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 76, height: 76)
                                .clipShape(Circle())

                            if vm.isEditing {
                                PhotosPicker(selection: $vm.selectedPhotoItem, matching: .images) {
                                    ZStack {
                                        Circle()
                                            .fill(Color.black.opacity(0.7))
                                            .frame(width: 28, height: 28)
                                        Image(systemName: "camera.fill")
                                            .foregroundColor(.yellow)
                                            .font(.system(size: 14))
                                    }
                                }
                                .onChange(of: vm.selectedPhotoItem) { _, _ in
                                    Task { await vm.loadSelectedImage() }
                                }
                                .offset(x: 4, y: 4)
                            }
                        }
                    }
                    .padding(.top, 12)

                    VStack(spacing: 12) {
                        if vm.isEditing {
                            editableCell(title: "First name", text: $vm.firstName)
                            editableCell(title: "Last name", text: $vm.lastName)
                          
                        } else {
                            displayCell(title: "First name", value: vm.firstName)
                            displayCell(title: "Last name", value: vm.lastName)
                            // displayCell(title: "Email", value: vm.email)
                        }
                    }
                    .padding(.horizontal, 16)

                    Spacer(minLength: 280)

                    if !vm.isEditing {
                        Button {
                            vm.signOut()
                        } label: {
                            Text("Sign Out")
                                .font(.system(size: 17))
                                .fontWeight(.semibold)
                                .foregroundColor(Color.red.opacity(0.9))
                                .frame(maxWidth: .infinity)
                                .frame(height: 44)
                                .background(Color.white.opacity(0.08))
                                .cornerRadius(8)
                        }
                        .padding(.horizontal, 16)
                        .padding(.bottom, 24)
                        .transition(.opacity.combined(with: .move(edge: .bottom)))
                    }
                }
            }
        }
        .background(Color.black.ignoresSafeArea())
    }

 
    @ViewBuilder
    private func displayCell(title: String, value: String) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .foregroundColor(.gray)
                .font(.caption)
            HStack {
                Text(value)
                    .foregroundColor(.white)
                    .font(.system(size: 17))
                    .fontWeight(.medium)
                Spacer()
            }
            .padding(.vertical, 10)
            .padding(.horizontal, 12)
            .background(
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .fill(Color.white.opacity(0.08))
            )
        }
    }

    @ViewBuilder
    private func editableCell(title: String,
                              text: Binding<String>,
                              keyboard: UIKeyboardType = .default,
                              autocap: TextInputAutocapitalization = .words) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .foregroundColor(.gray)
                .font(.caption)
            TextField("", text: text)
                .textInputAutocapitalization(autocap)
                .keyboardType(keyboard)
                .foregroundColor(.white)
                .font(.system(size: 17))
                .fontWeight(.medium)
                .padding(.vertical, 10)
                .padding(.horizontal, 12)
                .background(
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .fill(Color.white.opacity(0.12))
                )
        }
    }
}

#Preview {
    ProfileInfoView()
        .preferredColorScheme(.dark)
}

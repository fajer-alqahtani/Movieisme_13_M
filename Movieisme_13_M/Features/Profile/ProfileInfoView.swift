
import SwiftUI

struct ProfileInfoView: View {

    @EnvironmentObject var signInVM: SignInViewModel
    @StateObject private var vm = ProfileInfoViewModel()

    @Environment(\.dismiss) private var dismiss
    @State private var showSignOutAlert = false

    var body: some View {
        VStack(spacing: 0) {

            // Header
            HStack {
                Button {
                    dismiss()
                } label: {
                    HStack(spacing: 6) {
                        Image(systemName: "arrow.left")
                            .font(.system(size: 22, weight: .semibold))
                        Text("Back")
                    }
                }
                .foregroundColor(.yellow)

                Spacer()

                Button {
                    if vm.isEditing {
                        vm.saveChanges(signInVM: signInVM)
                    } else {
                        vm.enterEditMode()
                    }
                } label: {
                    Text(vm.isEditing ? "Save" : "Edit")
                        .font(.system(size: 17, weight: .semibold))
                }
                .foregroundColor(.yellow)
            }
            .padding(.horizontal, 16)
            .padding(.top, 12)
            .padding(.bottom, 8)

            ScrollView {
                VStack(spacing: 18) {

                    // Avatar (URL)
                    VStack(spacing: 10) {
                        UserAvatarView(
                            imageURLString: signInVM.signedInUser?.profileImage ?? "",
                            size: 76
                        )

                        Text("Profile image is saved as a URL")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.6))
                    }
                    .padding(.top, 12)

                    // Name fields
                    VStack(spacing: 12) {
                        if vm.isEditing {
                            editableCell(title: "First Name", text: $vm.firstName)
                            editableCell(title: "Last Name", text: $vm.lastName)
                          
                        } else {
                            displayCell(title: "First Name", value: vm.firstName)
                            displayCell(title: "Last Name", value: vm.lastName)
                            
                        }
                    }
                    .padding(.horizontal, 16)

                    // Email (read-only)
                    displayCell(title: "Email", value: vm.email)
                        .padding(.horizontal, 16)

                    if let err = vm.errorMessage, !err.isEmpty {
                        Text(err)
                            .foregroundColor(.red)
                            .font(.system(size: 14))
                            .padding(.horizontal, 16)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }

                    Spacer(minLength: 240)

                    // Sign Out when not editing
                    if !vm.isEditing {
                        Button {
                            showSignOutAlert = true
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
                        .alert("تسجيل الخروج", isPresented: $showSignOutAlert) {
                            Button("إلغاء", role: .cancel) { }
                            Button("تسجيل الخروج", role: .destructive) {
                                signInVM.signOut()
                                dismiss()
                            }
                        } message: {
                            Text("هل أنتِ متأكدة من تسجيل الخروج؟")
                        }
                    }
                }
            }
        }
        .background(Color.black.ignoresSafeArea())
        .foregroundColor(.white)
        .navigationBarBackButtonHidden(true)
        .onAppear {
            if let user = signInVM.signedInUser {
                vm.fillFromUser(user)
            }
        }
    }

    @ViewBuilder
    private func displayCell(title: String, value: String) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .foregroundColor(.gray)
                .font(.caption)

            HStack {
                Text(value.isEmpty ? "-" : value)
                    .foregroundColor(.white)
                    .font(.system(size: 17))
                    .fontWeight(.medium)
                Spacer()
            }
            .padding(.vertical, 10)
            .padding(.horizontal, 12)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.white.opacity(0.08))
            )
        }
    }

    @ViewBuilder
    private func editableCell(
        title: String,
        text: Binding<String>,
        keyboard: UIKeyboardType = .default,
        autocap: TextInputAutocapitalization = .words
    ) -> some View {
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
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.white.opacity(0.12))
                )
        }
    }
}

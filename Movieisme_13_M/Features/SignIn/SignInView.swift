import SwiftUI

struct SignInView: View {
    @EnvironmentObject var vm: SignInViewModel
    @FocusState private var focusedField: Field?

    enum Field {
        case email
        case password
    }

    var body: some View {
        NavigationStack {
            ZStack {

                Image("background")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()

                LinearGradient(
                    gradient: Gradient(colors: [
                        Color.black.opacity(0.85),
                        Color.black.opacity(0.35)
                    ]),
                    startPoint: .bottom,
                    endPoint: .top
                )
                .ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 14) {

                        Spacer(minLength: 340)

                        Text("Sign in")
                            .font(.system(size: 40))
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, alignment: .leading)

                        Text("You'll find what you're looking for in the ocean of movies")
                            .font(.system(size: 18))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, alignment: .leading)

                        Text("Email")
                            .font(.system(size: 18))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.top, 10)

                        TextField("Enter your email", text: $vm.email)
                            .frame(height: 44)
                            .foregroundColor(.white)
                            .padding(.horizontal, 12)
                            .background(Color.black.opacity(0.5))
                            .cornerRadius(10)
                            .textInputAutocapitalization(.never)
                            .keyboardType(.emailAddress)
                            .focused($focusedField, equals: .email)
                            .submitLabel(.next)
                            .onSubmit { focusedField = .password }

                        Text("Password")
                            .font(.system(size: 18))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.top, 10)

                        ZStack(alignment: .trailing) {
                            Group {
                                if vm.showPassword {
                                    TextField("Enter your password", text: $vm.password)
                                        .textInputAutocapitalization(.never)
                                } else {
                                    SecureField("Enter your password", text: $vm.password)
                                }
                            }
                            .frame(height: 44)
                            .foregroundColor(.white)
                            .padding(.horizontal, 12)
                            .background(Color.black.opacity(0.5))
                            .cornerRadius(10)
                            .focused($focusedField, equals: .password)
                            .submitLabel(.done)
                            .onSubmit { focusedField = nil }

                            Button {
                                vm.showPassword.toggle()
                            } label: {
                                Image(systemName: vm.showPassword ? "eye.slash.fill" : "eye.fill")
                                    .foregroundColor(.gray)
                            }
                            .padding(.trailing, 12)
                        }

                        if let error = vm.errorMessage {
                            Text(error)
                                .foregroundColor(.red)
                                .font(.system(size: 15))
                                .padding(.top, 4)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }

                        Button {
                            focusedField = nil
                            vm.signIn()
                        } label: {
                            ZStack {
                                Text(vm.isSigningIn ? "Signing in..." : "Sign in")
                                    .font(.system(size: 18))
                                    .fontWeight(.bold)
                                    .foregroundColor(.gray)
                                    .opacity(vm.isSigningIn ? 0 : 1)

                                if vm.isSigningIn {
                                    ProgressView()
                                        .tint(.gray)
                                }
                            }
                            .frame(height: 44)
                            .frame(maxWidth: .infinity)
                            .background(Color.white)
                            .cornerRadius(10)
                        }
                        .disabled(vm.isSigningIn)
                        .padding(.top, 12)

                        Spacer(minLength: 30)

                        NavigationLink(value: vm.signedInUser) {
                            EmptyView()
                        }
                        .hidden()
                    }
                    .padding(.horizontal, 38)
                }
                .scrollDismissesKeyboard(.interactively)
            }
            .navigationDestination(item: Binding(
                get: { vm.signedInUser },
                set: { _ in }
            )) { user in
                MoviesView()
                    .environmentObject(vm)
                    .navigationBarBackButtonHidden(true)
            }
        }
    }
}

#Preview {
    SignInView()
}


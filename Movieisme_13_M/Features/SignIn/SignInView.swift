import SwiftUI

struct SignInView: View {
    @StateObject private var vm = SignInViewModel()

    var body: some View {
        VStack {
            ZStack {
                Image("background")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .edgesIgnoringSafeArea(.all)
                    .frame(height: 1200)

                LinearGradient(
                    gradient: Gradient(colors: [Color.black, Color.black.opacity(0.3)]),
                    startPoint: .bottom,
                    endPoint: .top
                )

                VStack(spacing: 10) {
                    Text("Sign in")
                        .font(.system(size: 40))
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.trailing, 200)

                    Text("You'll find what you're looking for in the ocean of movies")
                        .frame(width: 318)
                        .lineLimit(2)
                        .font(.system(size: 18))
                        .foregroundColor(.white)

                    Text("Email")
                        .font(.system(size: 18))
                        .foregroundColor(.white)
                        .padding(.trailing, 260)
                        .padding(.vertical, 10)

                    TextField("Enter your email", text: $vm.email)
                        .frame(width: 358, height: 44)
                        .foregroundColor(.white)
                        .background(Color.black.opacity(0.5))
                        .padding(.horizontal, 12)
                        .cornerRadius(10)
                        .textInputAutocapitalization(.never)
                        .keyboardType(.emailAddress)

                    Text("Password")
                        .font(.system(size: 18))
                        .foregroundColor(.white)
                        .padding(.trailing, 260)
                        .padding(.vertical, 10)

                    ZStack(alignment: .trailing) {
                        Group {
                            if vm.showPassword {
                                TextField("Enter your password", text: $vm.password)
                                    .foregroundColor(.white)
                                    .textInputAutocapitalization(.never)
                            } else {
                                SecureField("Enter your password", text: $vm.password)
                                    .foregroundColor(.white)
                            }
                        }
                        .frame(width: 358, height: 44)
                        .padding(.horizontal, 12)
                        .background(Color.black.opacity(0.5))
                        .cornerRadius(10)

                        Button {
                            vm.showPassword.toggle()
                        } label: {
                            Image(systemName: vm.showPassword ? "eye.slash.fill" : "eye.fill")
                                .foregroundColor(.gray)
                        }
                        .padding(.trailing, 24)
                    }

                    if let error = vm.errorMessage {
                        Text(error)
                            .foregroundColor(.red)
                            .font(.system(size: 15))
                            .padding(.top, 4)
                    }

                    Button {
                        vm.signIn()
                    } label: {
                        Text("Sign in")
                            .font(.system(size: 18))
                            .fontWeight(.bold)
                            .foregroundColor(.gray)
                            .frame(width: 358, height: 44)
                            .background(Color.white)
                            .cornerRadius(10)
                    }
                    .padding()
                }
                .padding(.top, 360)
            }
        }
    }
}

#Preview {
    SignInView()
}

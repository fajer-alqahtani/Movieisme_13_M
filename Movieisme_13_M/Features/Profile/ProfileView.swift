import SwiftUI

struct ProfileView: View {
    @State var savedMovies: [String] = []
    @State var movies: [String] = []
    @Environment(\.dismiss) private var dismiss
    

    @EnvironmentObject var signInVM: SignInViewModel

    var body: some View {

            ScrollView {
                VStack(alignment: .leading, spacing: 20) {

                    HStack {
                        Button {
                            dismiss()
                        } label: {
                            HStack(spacing: 6) {
                                Image(systemName: "arrow.left")
                                    .font(.system(size: 25))
                                    .foregroundColor(.yellow)

                                Text("Back")
                                    .font(.system(size: 20))
                                    .foregroundColor(.yellow)
                            }
                        }
                        Spacer()
                    }

                    Text("Profile")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)

                    ZStack {
                        Rectangle()
                            .frame(height: 80)
                            .foregroundColor(.gray.opacity(0.2))
                            .cornerRadius(10)

                        HStack {
                     

                            UserAvatarView(imageURLString: signInVM.signedInUser?.profileImage ?? "")
                                .frame(width: 41, height: 41)
                                .clipShape(Circle())
                            
                            
                            VStack(alignment: .leading, spacing: 5) {
                                // 2. Replace hardcoded name with variable
                                Text(signInVM.signedInUser?.name ?? "Sarah Abdullah")
                                    .font(.system(size: 18))
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)

                                // 3. Replace hardcoded email with variable
                                Text(signInVM.signedInUser?.email ?? "Xxxx234@gmail.com")
                                    .foregroundColor(.white)
                                    .font(.system(size: 12))
                            }

                            Spacer()

                            NavigationLink {
                                ProfileInfoView()
                                    .navigationBarBackButtonHidden(true)
                            } label: {
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.white.opacity(0.8))
                                    .font(.system(size: 17, weight: .semibold))
                                    .padding(8)
                            }
                            .buttonStyle(.plain)
                        }
                        .padding(.horizontal, 16)
                    }

                    Text("Saved movies")
                        .font(.system(size: 22))
                        .fontWeight(.bold)
                        .foregroundColor(.white)

                    if savedMovies.isEmpty {
                        VStack(spacing: 16) {
                            Image(systemName: "video.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 64, height: 64)
                                .foregroundColor(.white.opacity(0.13))

                            Text("No saved movies yet, start save your favourites")
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .multilineTextAlignment(.center)
                                .foregroundColor(.white.opacity(0.45))
                                .frame(width: 260)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 8)
                    }

                    Spacer(minLength: 16)
                }
                .padding(.top, 48)
                .padding(.horizontal, 24)
            }
            .background(Color.black.ignoresSafeArea())
            .navigationBarBackButtonHidden(true)
        
    }
}





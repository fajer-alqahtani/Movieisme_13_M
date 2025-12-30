//
//  ProfileView.swift
//  Movieisme_13_M
//
//  Created by Yousra Abdelrahman on 04/07/1447 AH.
//



import SwiftUI

struct ProfileView: View {
    @State var savedMovies: [String] = []
    @State var movies: [String] = []
    var body: some View {
        
        
    VStack(alignment: . leading, spacing: 20) {
        
        HStack{
            Image(systemName: ("arrow.left"))
                .font(.system(size: 25))
                .foregroundColor(.yellow)
            Text("Back")
                .font(.system(size:20))
                .foregroundColor(.yellow)
        }
            Text("Profile")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.white)

        
    
        
            ZStack{
                
        Rectangle()
        .frame(width: 390, height: 80)
        .foregroundColor(.gray.opacity(0.2))
            .cornerRadius(10)
                
                HStack() {
                    Image("avatar")
            
                  
    VStack(alignment : .leading , spacing: 5){
                        Text("Sarah Abdullah")
                .font(.system(size:18))
            .font(.headline)
                .fontWeight(.bold)
                    .foregroundColor(.white)
                Text("Xxxx234@gmail.com")
                .foregroundColor(.white)
                .tint(.white)
                .font(.system(size:12))
                
                    
               
    }
                    Spacer()
                    
                    
                    Image(systemName: ("chevron.right"))
                
                }
               
                .padding(.horizontal , 16)
            }
        Text("Saved movies")
            .font(.system(size:22))
            .fontWeight(.bold)
            
            
                
        Spacer()
                
        VStack{
            if movies.isEmpty {
                // شاشة فاضية
            } else {
                // عرض الأفلام
            }
        }
            
                    
                }
  
                        
                    
        
                    
               
        
            
            
            
            
            
            
            
        }}
#Preview {
    ProfileView()
        .preferredColorScheme(.dark)
}

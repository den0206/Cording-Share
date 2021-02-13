//
//  Login_MacView.swift
//  Cording-Share
//
//  Created by 酒井ゆうき on 2021/02/13.
//

import SwiftUI

struct Login_MacView: View {
    
    @State private var user = AuthUserViewModel()
        
    var body: some View {
        
        HStack {
            Spacer()
            
            VStack {
                
                Spacer()
                
                Text("Login")
                    .font(.title)
                    .bold()
                
                Group {
                    ValitationText(text: user.validEmailText, confirm: !user.validEmailText.isEmpty)
                    
                
                    CustomTextField(text: $user.email, placeholder: "Email", imageName: "envelope")
                        .padding(.bottom,8)
                        
                    CustomTextField(text: $user.password, placeholder: "password", imageName: "lock", isSecure: true)
                }
                .padding()
                
                VStack(spacing :10) {
                    
                    CustomButton(title: "Login", disable: user.isLoginComplete, backColor: .blue, action: {print("Login")})
                    
                    CustomButton(title: "Sign Up", disable: true, backColor: .green, action: {print("Sign Up")})
                    
                    
                }
                
                
                Spacer()
              
                
                
                
            }
            .frame(maxWidth: .infinity,maxHeight: .infinity)
            
            Divider()
                .background(Color.primary)
            
            VStack {
                Spacer()
            }
            .frame(width: (getScreenSize.width / 1.8) / 2)
            
        }
        .foregroundColor(.primary)
        .ignoresSafeArea(.all, edges: .all)
        .preferredColorScheme(.dark)
        
    }
}

struct Login_MacView_Previews: PreviewProvider {
    static var previews: some View {
        Login_MacView()
    }
}

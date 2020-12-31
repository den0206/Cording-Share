//
//  LoginView.swift
//  Cording-Share
//
//  Created by 酒井ゆうき on 2020/12/30.
//

import SwiftUI

struct LoginView: View {
    
    enum loginviewSheet : Identifiable {
        case signUp, resetPassword
        
        var id : Int {
            hashValue
        }
    }
    
    @State private var user = AuthUserViewModel()
    @State private var sheetType : loginviewSheet?
    
    var body: some View {
        
        VStack(spacing :20) {
            
            Spacer()
        
            CustomTextField(text: $user.email, placeholder: "Email", imageName: "envelope")
                
            CustomTextField(text: $user.password, placeholder: "password", imageName: "lock", isSecure: true)
            
           
            
            HStack {
                Spacer()
                
                Button(action: {self.sheetType = .resetPassword}) {
                    Text("Reset Password")
                        .foregroundColor(.gray)
                }
            }
            .padding(.vertical)
            .padding(.trailing,10)
            
            VStack(spacing :10) {
                
                Button(action: {}) {
                    Text("Login")
                        .foregroundColor(.white)
                        .padding(.vertical,15)
                        .frame(width: 200)
                        .background(Color.green)
                        .cornerRadius(8)
                        .opacity(user.isLoginComplete ? 1 : 0.3)
                }
                .disabled(!user.isLoginComplete)
                
                Button(action: {self.sheetType = .signUp}) {
                    Text("SignUp")
                        .foregroundColor(.white)
                        .padding(.vertical,15)
                        .frame(width: 200)
                        .background(Color.blue)
                        .cornerRadius(8)
                }
                
            }
            .sheet(item: $sheetType) { (item) in
                
                switch item {
                case .signUp :
                    SignUpView()
                    
                case .resetPassword :
                    Text("Reset Pasword")
                }
            }
            
            Spacer()
        }
        .background(Color(.systemGroupedBackground).ignoresSafeArea(.all, edges: .all) )
    }
}


struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}

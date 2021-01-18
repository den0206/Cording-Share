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
    
    @State private var authError : EmailAuthError?
    @State private var showAlert = false
    @State private var isLoading = false
    
    var body: some View {
        
        VStack {
            
            Spacer()
            
            ValitationText(text: user.validEmailText, confirm: !user.validEmailText.isEmpty)
        
            CustomTextField(text: $user.email, placeholder: "Email", imageName: "envelope")
                .padding(.bottom,8)
                
            CustomTextField(text: $user.password, placeholder: "password", imageName: "lock", isSecure: true)
            
           
            
            HStack {
                Spacer()
                
                Button(action: {self.sheetType = .resetPassword}) {
                    Text("Reset Password")
                        .foregroundColor(.black)
                }
            }
            .padding(.vertical)
            .padding(.trailing,10)
            
            VStack(spacing :10) {
                
                Button(action: {loginUser()}) {
                    Text("Login")
                        .foregroundColor(.white)
                        .padding(.vertical,15)
                        .frame(width: 200)
                        .background(Color.green)
                        .cornerRadius(8)
                        .opacity(user.isLoginComplete ? 1 : 0.3)
                }
                .disabled(!user.isLoginComplete)
                .alert(isPresented: $showAlert) { () -> Alert in
                    Alert(title: Text("Error"), message: Text(authError?.localizedDescription ?? "UnknownError"), dismissButton: .default(Text("OK")) {
                        /// reset
                        if authError == .incorrectPassword {
                            user.password = ""
                        } else {
                            user.email = ""
                            user.password = ""
                        }
                    })
                }
                
                Button(action: {sheetType = .signUp}) {
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
        .background(Color(.systemGroupedBackground).ignoresSafeArea(.all, edges: .all))
        .Loading(isShowing: $isLoading)
        .onTapGesture(perform: {
            hideKeyBord()
        })
        
    }
    
    //MARK: - Login
    
    private func loginUser() {
        isLoading = true
        
        FBAuth.loginUser(email: user.email, password: user.password) { (result) in
            
            switch result {
            
            case .success(_):
                print("Success")
     
            case .failure(let error):
                authError = error
                showAlert = true
            }
            
            isLoading = false
        }
    }
}


struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}

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
    /// for not internet
    @State private var errorMessage = ""
    @State private var showAlert = false
    
    @Binding var isLoading : Bool
    //    @State private var isLoading = false
    
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
                        .foregroundColor(.primary)
                }
            }
            .padding(.vertical)
            .padding(.trailing,10)
            
            VStack(spacing :10) {
                
                CustomButton(title: "Login", disable: user.isLoginComplete, backColor: .green, action: {loginUser()})
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
                
                
                CustomButton(title: "SignUp", disable: true, backColor: .blue, action: {sheetType = .signUp})
                
                
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
        
        .Loading(isShowing: !isMacOS ? $isLoading : .constant(false))
        .onTapGesture(perform: {
            hideKeyBord()
        })
        
    }
    
    //MARK: - Login
    
    private func loginUser() {
        
        guard Reachabilty.HasConnection() else {
            errorMessage = "No Internet"
            showAlert = true
            return
        }
        
        
        isLoading = true
        
        FBAuth.loginUser(email: user.email, password: user.password) { (result) in
            
            switch result {
            
            case .success(let uid):
                print("Success\(uid)")
                
            case .failure(let error):
                
                authError = error
                showAlert = true
            }
            
            isLoading = false
        }
    }
 
}

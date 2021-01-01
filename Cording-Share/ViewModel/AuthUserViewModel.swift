//
//  AuthUserViewModel.swift
//  Cording-Share
//
//  Created by 酒井ゆうき on 2020/12/30.
//

import Foundation
import UIKit

struct AuthUserViewModel {

    var email = ""
    var fullname = ""
    var password = ""
    var confirmPassword = ""
    var imageData : Data = .init(count: 0)
    
//    var currentUser : FBUser?
    
    var isLoginComplete : Bool {
        
        if isEmpty(_field: email) || isEmpty(_field: password) ||  !isEmalValid(_email: email){
            return false
        }
        return true
    }
    
    var isSignupComplete : Bool {
        
        
        if testMode {
            if !selectedImage() || !isEmalValid(_email: email) || isEmpty(_field: fullname) || !passwordMatch(_confirmPass: confirmPassword) || isEmpty(_field: password){
                return false
            }
            
            return true
        } else {
            if !selectedImage() || !isEmalValid(_email: email) || isEmpty(_field: fullname) || !passwordMatch(_confirmPass: confirmPassword) || !isPasswordValid(_password: password) {
                return false
            }
            
            return true
        }
        
    }
    
//    var didChangeStatus : Bool {
//
//        guard let currentUser = currentUser else {return false}
//
//        if currentUser.name != fullname || currentUser.email != email  || !(self.imageData == .init(count :0)){
//            return true
//        }
//
//        return false
//    }
//
    
    //MARK: - validation
    
    func selectedImage() -> Bool {
        return !(imageData == .init(count: 0))
    }
    
    func passwordMatch(_confirmPass : String) -> Bool {
        
        guard !password.isEmpty else {return false}
        return _confirmPass == password
    }
    
    
    func isEmalValid(_email : String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegex)
        return emailTest.evaluate(with: email)
        
    }
    
    func isPasswordValid(_password : String) -> Bool {
        let passwordRegEx = "^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d]{8,}$"
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", passwordRegEx)
        
        return passwordTest.evaluate(with: password)
    }
    
    //MARK: - Error String
    
    var validImageText : String {
        
        if selectedImage() {
            return ""
        } else {
            return "画像を選択してください"
        }
    }
    
    var validNameText : String {
        
        if !isEmpty(_field: fullname) {
            return ""
        } else {
            return "名前を入力してください"
        }
    }
    
    var validEmailText : String {
        if isEmalValid(_email: email) {
            return ""
        } else {
            return "Emailの書式を入力してください"
        }
    }
    
    var validPasswordText : String {
        if isPasswordValid(_password: password){
            return ""
        } else {
            return "8文字以上で、大文字もふくめてください"
        }
    }
    
    var validConfirmPasswordText : String {
        if passwordMatch(_confirmPass: confirmPassword) {
            return ""
        } else {
            return "確認用パスワードが一致しません"
        }
    }
    
    
}

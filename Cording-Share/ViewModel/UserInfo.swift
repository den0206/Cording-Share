//
//  UserInfo.swift
//  Cording-Share
//
//  Created by 酒井ゆうき on 2020/12/31.
//

import FirebaseAuth

final class UserInfo : ObservableObject {
    
    enum AuthState {
        case undifined, signOut, signIn
    }
    
    @Published var isUserauthenticated : AuthState = .undifined
    @Published var user : FBUser = .init(uid : "", name : "", email : "")
    

    var listnerHandle : AuthStateDidChangeListenerHandle?

    func configureStateDidChange() {
        
        listnerHandle = Auth.auth().addStateDidChangeListener({ (_, user) in
            
            guard let user = user else {
                self.isUserauthenticated = .signOut
                return
            }
            self.isUserauthenticated = .signIn
        })
    }
}

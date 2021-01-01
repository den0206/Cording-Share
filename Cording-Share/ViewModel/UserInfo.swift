//
//  UserInfo.swift
//  Cording-Share
//
//  Created by 酒井ゆうき on 2020/12/31.
//

import SwiftUI
import CodeMirror_SwiftUI
import FirebaseAuth

final class UserInfo : ObservableObject {
    
    enum AuthState {
        case undifined, signOut, signIn
    }
    
    @Published var isUserauthenticated : AuthState = .undifined
    @Published var user : FBUser = .init(uid : "", name : "", email : "")
    
    @Published var tabIndex = 0
    @Published var showTab = true
    
    
    @AppStorage("fontSize") var fontSize : Int = 10
    @AppStorage("themeIndex") var themeIndex : Int = 8
    @AppStorage("modeIndex") var modeIndex : Int = 0
    
    
    var modes = CodeMode.list()
    
    var mode : Mode {
        return modes[modeIndex]
    }
    
    var themes = CodeViewTheme.allCases.sorted {
        return $0.rawValue < $1.rawValue
    }
    
    var theme : CodeViewTheme {
        return themes[themeIndex]
    }
    
    

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

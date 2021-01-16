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
    
    @Published var loading = false
    @Published var showHUD = false
    
    @Published var MSGPushNav = false
    
    
    @AppStorage("fontSize") var fontSize : Int = 10
    @AppStorage("themeIndex") var themeIndex : Int = 8
    @AppStorage("modeIndex") var modeIndex : Int = 0
    
    var modes = CodeMode.codeModes
    
    var mode : CodeMode {
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
            
            FBAuth.fecthFBUser(uid: user.uid) { (result) in
                switch result {
                
                case .success(let user):
                    self.user = user
                    self.isUserauthenticated = .signIn

                case .failure(_):
                    self.isUserauthenticated = .signOut
                }
            }
            
            
        })
    }
    
    //MARK: - Modes
    
    func setCodeMode(codeMode : CodeMode) {
        self.modeIndex = modes.firstIndex(of: codeMode)!
    }
    
    //MARK: - HUd $ Loading
    
    func copyText(text : String) {
        UIPasteboard.general.string = text
        showHUD = true
    }
    
}

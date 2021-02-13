//
//  RootView.swift
//  Cording-Share
//
//  Created by 酒井ゆうき on 2020/12/31.
//

import SwiftUI


struct RootView : View {
    
    @EnvironmentObject var userInfo : UserInfo
    
    var body: some View {
        
        #if !targetEnvironment(macCatalyst)
        
        Group {
            if userInfo.isUserauthenticated == .undifined {
                ProgressView("Loading...")
                    .foregroundColor(.green)
                    .progressViewStyle(CircularProgressViewStyle(tint: Color.green))
                 
                    .padding()
                    .transition(AnyTransition.fade(duration: 0.5))
            }  else if userInfo.isUserauthenticated == .signOut {
                LoginView()
            } else {
                MainTabView()
            }
        }
        .preferredColorScheme(.dark)
        .onAppear(perform: {
            userInfo.configureStateDidChange()
        })
        
        #else
        //MARK: - MacOS
        
        Login_MacView()
        
        #endif
        
    }
}

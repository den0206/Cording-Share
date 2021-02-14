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
        
        
        Group {
            if userInfo.isUserauthenticated == .undifined {
                ProgressView("Loading...")
                    .foregroundColor(.green)
                    .progressViewStyle(CircularProgressViewStyle(tint: Color.green))
                 
                    .padding()
                    .transition(AnyTransition.fade(duration: 0.5))
            }  else if userInfo.isUserauthenticated == .signOut {
                AuthenticationView()
            } else {
                if !isMacOS {
                    MainTabView()
                } else {
                    MainSideView()
                }
               
            }
        }
        .preferredColorScheme(.dark)
        .onAppear(perform: {
            userInfo.configureStateDidChange()
        })
        
        
    }
}

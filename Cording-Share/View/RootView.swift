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
                GreenProgressView()
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

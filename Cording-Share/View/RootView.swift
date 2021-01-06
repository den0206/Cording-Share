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
                    .foregroundColor(.primary)
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
        
    }
}

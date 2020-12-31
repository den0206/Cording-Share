//
//  Cording_ShareApp.swift
//  Cording-Share
//
//  Created by 酒井ゆうき on 2020/12/30.
//

import SwiftUI
import Firebase

public var testMode = true

@main
struct Cording_ShareApp: App {
    
    var userInfo = UserInfo()
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(userInfo)
        }
    }
}

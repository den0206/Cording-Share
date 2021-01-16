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
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
//            RootView()
            MainTabView()
                .environmentObject(userInfo)
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    
    static var orientationLock = UIInterfaceOrientationMask.portrait

    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        return true
    }
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return AppDelegate.orientationLock
    }
}

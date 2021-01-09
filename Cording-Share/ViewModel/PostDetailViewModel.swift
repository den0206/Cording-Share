//
//  PostDetailVieewModel.swift
//  Cording-Share
//
//  Created by 酒井ゆうき on 2021/01/09.
//

import SwiftUI

final class PostDetailViewModel : ObservableObject{
    
    var post : Post
    
    @Published var errorMessage = ""
    @Published var showALert = false
    
    @Published var loading = true
    @Published var fullScreen = false

    init(post : Post) {
        self.post = post
    }
    
    
    func getPostUser() {
        FBPost.getPostUser(post: post) { (result) in
            switch result {
            
            case .success(let user):
                self.post.user = user
            case .failure(let error):
                self.errorMessage = error.localizedDescription
                self.showALert = true
            }
        }
    }
    
    func fullScreenMode() {
        
        switch fullScreen {
        case true:
            DispatchQueue.main.async {
                AppDelegate.orientationLock = UIInterfaceOrientationMask.portrait
                UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
                UINavigationController.attemptRotationToDeviceOrientation()
               
            }
        case false :
            
            DispatchQueue.main.async {
                AppDelegate.orientationLock = UIInterfaceOrientationMask.landscape
                UIDevice.current.setValue(UIInterfaceOrientation.landscapeLeft.rawValue, forKey: "orientation")
                UINavigationController.attemptRotationToDeviceOrientation()
            
            }
        }
        
        fullScreen.toggle()
    }
}

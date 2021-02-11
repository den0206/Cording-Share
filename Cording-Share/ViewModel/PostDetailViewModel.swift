//
//  PostDetailVieewModel.swift
//  Cording-Share
//
//  Created by 酒井ゆうき on 2021/01/09.
//

import SwiftUI

final class PostDetailViewModel : ObservableObject{
    
    var post : Post
    
    @Published var showALert = false
    
    @Published var alert = Alert(title: Text(""))
    @Published var fullScreen = false
    @Published var showProfile = false

    init(post : Post) {
        self.post = post
    }
    
    
    func getPostUser() {
        FBPost.getPostUser(post: post) { (result) in
            switch result {
            
            case .success(let user):
                self.post.user = user
            case .failure(let error):
                self.alert = errorAlert(message: error.localizedDescription)
                self.showALert = true
            }
        }
    }
    
    func fullScreenMode() {
        
        switch fullScreen {
        case true:
            fixOrientation(landscape: false)
        case false :
            fixOrientation(landscape: true)
          
        }
        
        fullScreen.toggle()
    }
    
    //MARK: - Edit & Delete Post
    
    func showDeleteAlert(userInfo : UserInfo){
        alert = Alert(title: Text("確認"), message: Text("Postを削除してもよろしいですか？"), primaryButton: .cancel(), secondaryButton: .default(Text("削除"), action: {
            
            self.deletePost(userInfo: userInfo)
        }))
        
        showALert = true
    }
    
    func deletePost(userInfo : UserInfo) {
        
        userInfo.loading = true
        
        FBPost.deleteItem(post: post, usetId: userInfo.user.uid) { (result) in
            
            switch result {
            
            case .success(let bool):
                print("Success\(bool)")
            case .failure(let error):
                self.alert = errorAlert(message: error.localizedDescription)
            }
            
            userInfo.loading = false
        }
    }
}

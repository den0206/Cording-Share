//
//  FeedViewModel.swift
//  Cording-Share
//
//  Created by 酒井ゆうき on 2021/01/01.
//


import SwiftUI

final class FeedViewModel : ObservableObject {
    
    @Published var posts = [Post]()
    
    @Published var errorMessage = ""
    @Published var showalert = false
    
    func fetchPosts(userId : String) {
        
        FBPost.fetchPosts(userId: userId) { (result) in
            switch result {
            
            case .success(let posts):
                self.posts = posts
                print(posts[1].codeBlock)
            case .failure(let error):
                print(error.localizedDescription)
                self.errorMessage = error.localizedDescription
                self.showalert = true
            }
        }
    }
    
}

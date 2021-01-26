//
//  FeedViewModel.swift
//  Cording-Share
//
//  Created by 酒井ゆうき on 2021/01/01.
//


import SwiftUI
import FirebaseFirestore

final class FeedViewModel : ObservableObject {
    
    @Published var posts = [Post]()
    
    @Published var errorMessage = "" {
        didSet {
            showalert = true
        }
    }
    @Published var showalert = false
    
    func fetchPosts(userId : String) {
        
        FBPost.fetchPosts(userId: userId) { (result) in
            switch result {
            
            case .success(let posts):
                self.posts = posts
            case .failure(let error):
                print(error.localizedDescription)
                self.errorMessage = error.localizedDescription
                self.showalert = true
            }
        }
    }
    
    func fetchPost() {
        
        var ref : Query!

        ref = Firestore.firestore().collectionGroup(PostKey.posts).order(by: PostKey.date, descending: true).limit(to: 5)
        
        ref.getDocuments { (snapshot, error) in
            
            if let error = error {
                self.errorMessage = error.localizedDescription
                return
            }
            
            guard let snapshot = snapshot else {
                self.errorMessage = FirestoreError.noDocumentSNapshot.localizedDescription
                return}
            
            guard !snapshot.isEmpty else {
                self.errorMessage = FirestoreError.emptySnapshot.localizedDescription
                return}
            
            snapshot.documents.forEach { (doc) in
                let data = doc.data()
                var post = Post(dic: data)
                
                FBAuth.fecthFBUser(uid: post.userId) { (result) in
                    switch result {
                    
                    case .success(let user):
                        post.user = user
                        self.posts.append(post)

                    case .failure(let error):
                        self.errorMessage = error.localizedDescription
                    }
                }
            }
            
        }
    }
    
}

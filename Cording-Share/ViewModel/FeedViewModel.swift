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
    
    @Published var reachLast = false
    @Published var lastDoc : DocumentSnapshot?
    
    @Published var errorMessage = "" {
        didSet {
            showalert = true
        }
    }
    @Published var showalert = false
    
    
    let limit = 5
    
  
    func fetchPost() {
        
        guard !reachLast else {return}
        
        var ref : Query!
        
        if lastDoc == nil {
            ref = Firestore.firestore().collectionGroup(PostKey.posts).order(by: PostKey.date, descending: true).limit(to: limit)
            
        } else {
            ref = Firestore.firestore().collectionGroup(PostKey.posts).order(by: PostKey.date, descending: true).start(afterDocument: lastDoc!).limit(to: limit)
        }
        
        
        ref.getDocuments { (snapshot, error) in
            
            if let error = error {
                self.errorMessage = error.localizedDescription
                return
            }
            
            guard let snapshot = snapshot else {
                self.errorMessage = FirestoreError.noDocumentSNapshot.localizedDescription
                return}
            
            guard !snapshot.isEmpty else {
                self.reachLast = true
                return}
            
            snapshot.documents.forEach { (doc) in
                let data = doc.data()
                let post = Post(dic: data)
                
                self.posts.append(post)
                
            }
            
            self.lastDoc = snapshot.documents.last
            
        }
    }
    
}

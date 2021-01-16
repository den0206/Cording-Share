//
//  FBPost.swift
//  Cording-Share
//
//  Created by 酒井ゆうき on 2021/01/03.
//

import Firebase
import CodeMirror_SwiftUI

struct FBPost {
    
    static func craeteNewPost(data : Data, userId : String, language : CodeMode, description : String ,completion : @escaping(Result<Post, Error>) -> Void) {
        
        let postId = UUID().uuidString
    
        let fileName = "sources/" + "\(userId)/" + postId + ".txt"
        
        
        saveFileFirestore(data: data, fileName: fileName) { (result) in
            
            switch result {
            
            case .success(let codeUrl):
                
                var data = [PostKey.postId : postId,
                            PostKey.userID : userId,
                            PostKey.codeUrl : codeUrl,
                            PostKey.language : language.rawValue,
                            PostKey.date : Timestamp(date: Date())
                            
                ] as [String : Any]
                
                
                if description != "" {
                    data[PostKey.description] = description
                }
                
                FirebaseReference(.User).document(userId).collection(PostKey.posts).document(postId).setData(data) { (error) in
                    
                    if let error = error {
                        completion(.failure(error))
                        return
                    }
                }
                
                let post = Post(dic: data)
                
                completion(.success(post))
            case .failure(let error):
                print(error.localizedDescription)
                completion(.failure(error))
            }
        }
       
    }
    
    static func deleteItem(post : Post, usetId : String,completion :@escaping(Result<Bool, Error>) -> Void) {
        
        guard post.userId == usetId else {completion(.failure(FirestoreError.noUser))
            return
        }
        
        let strogeRef = Storage.storage().reference()
        
        FirebaseReference(.User).document(usetId).collection(PostKey.posts)
            .document(post.id).delete { (error) in
                
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                strogeRef.child("sources").child(usetId).child("\(post.id).txt").delete { (error) in
                    
                    if let error = error{
                        completion(.failure(error))
                        return
                    }
                    
                    completion(.success(true))
                }
            }
        
        
    }
}

extension FBPost {
    
    static func fetchPosts(userId : String, completion : @escaping(Result<[Post], Error>) -> Void) {
        
        var posts = [Post]()
        var ref : Query!
        
        ref = Firestore.firestore().collectionGroup(PostKey.posts).order(by: PostKey.date, descending: true).limit(to: 5)
        
        ref.getDocuments { (snapshot, error) in
            
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let snapshot = snapshot else {
                completion(.failure(FirestoreError.noDocumentSNapshot))
                return}
            
            guard !snapshot.isEmpty else {
                completion(.failure(FirestoreError.emptySnapshot))
                return}
            
            snapshot.documents.forEach { (doc) in
                let data = doc.data()
                let post = Post(dic: data)
                
                posts.append(post)
            }
            
            completion(.success(posts))
        }
    }
    
    static func getPostUser(post : Post, completion : @escaping(Result<FBUser, Error>) -> Void) {
        
        let userID = post.userId
        
        FBAuth.fecthFBUser(uid: userID) { (result) in
            switch result {
            
            case .success(let user):
                completion(.success(user))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
